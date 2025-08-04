# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'
require 'httparty'
require 'dotenv/load'
require 'json'

class App < Sinatra::Base
  configure do
    set :public_folder, 'public'
    set :views, 'views'
    set :port, ENV['PORT'] || 3000
    enable :method_override
  end

  # Configuration for Supabase
  SUPABASE_URL = ENV['SUPABASE_URL']
  SUPABASE_KEY = ENV['SUPABASE_KEY']

  helpers do
    def supabase_headers
      {
        'apikey' => SUPABASE_KEY,
        'Authorization' => "Bearer #{SUPABASE_KEY}",
        'Content-Type' => 'application/json'
      }
    end

    def number_with_delimiter(number)
      number.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
    end

    def supabase_request(method, endpoint, data = nil)
      url = "#{SUPABASE_URL}/rest/v1/#{endpoint}"
      
      begin
        response = case method.upcase
        when 'GET'
          HTTParty.get(url, headers: supabase_headers.merge('Accept-Encoding' => 'identity'))
        when 'POST'
          HTTParty.post(url, headers: supabase_headers.merge('Accept-Encoding' => 'identity'), body: data.to_json)
        when 'PATCH'
          HTTParty.patch(url, headers: supabase_headers.merge('Accept-Encoding' => 'identity'), body: data.to_json)
        when 'DELETE'
          HTTParty.delete(url, headers: supabase_headers.merge('Accept-Encoding' => 'identity'))
        end
        
        response
      rescue => e
        OpenStruct.new(success?: false, parsed_response: [], message: e.message)
      end
    end
  end

  # Routes
  get '/' do
    erb :index
  end

  # Product Management Routes
  get '/products' do
    response = supabase_request('GET', 'products?select=*')
    
    if response.success?
      @products = response.parsed_response || []
    else
      @products = []
    end
    
    erb :products
  end

  get '/products/new' do
    erb :product_form
  end

  post '/products' do
    product_data = {
      name: params[:name],
      description: params[:description],
      price: params[:price].to_f,
      stock: params[:stock].to_i,
      created_at: Time.now.iso8601
    }

    response = supabase_request('POST', 'products', product_data)
    
    if response.success?
      redirect '/products'
    else
      @error = "Gagal menambahkan produk"
      erb :product_form
    end
  end

  get '/products/:id/edit' do
    response = supabase_request('GET', "products?id=eq.#{params[:id]}")
    @product = response.parsed_response.first if response.success?
    
    if @product
      erb :product_edit
    else
      redirect '/products'
    end
  end

  patch '/products/:id' do
    product_data = {
      name: params[:name],
      description: params[:description],
      price: params[:price].to_f,
      stock: params[:stock].to_i,
      updated_at: Time.now.iso8601
    }

    response = supabase_request('PATCH', "products?id=eq.#{params[:id]}", product_data)
    
    if response.success?
      redirect '/products'
    else
      @error = "Gagal mengupdate produk"
      @product = { 'id' => params[:id] }
      erb :product_edit
    end
  end

  delete '/products/:id' do
    response = supabase_request('DELETE', "products?id=eq.#{params[:id]}")
    
    if response.success?
      json({ success: true })
    else
      json({ success: false, error: "Gagal menghapus produk" })
    end
  end

  # Purchase History Routes
  get '/purchases' do
    response = supabase_request('GET', 'purchases?select=*,products(*)')
    @purchases = response.parsed_response if response.success?
    @purchases ||= []
    erb :purchases
  end

  get '/purchases/new' do
    products_response = supabase_request('GET', 'products?select=*')
    @products = products_response.parsed_response if products_response.success?
    @products ||= []
    erb :purchase_form
  end

  post '/purchases' do
    # Get product info
    product_response = supabase_request('GET', "products?id=eq.#{params[:product_id]}")
    product = product_response.parsed_response.first if product_response.success?

    if product && product['stock'] >= params[:quantity].to_i
      purchase_data = {
        product_id: params[:product_id].to_i,
        quantity: params[:quantity].to_i,
        total_price: product['price'] * params[:quantity].to_i,
        purchase_date: Time.now.iso8601,
        status: 'completed'
      }

      # Create purchase
      purchase_response = supabase_request('POST', 'purchases', purchase_data)
      
      if purchase_response.success?
        # Update product stock
        new_stock = product['stock'] - params[:quantity].to_i
        stock_update = { stock: new_stock }
        supabase_request('PATCH', "products?id=eq.#{params[:product_id]}", stock_update)
        
        redirect '/purchases'
      else
        @error = "Gagal membuat pembelian"
        products_response = supabase_request('GET', 'products?select=*')
        @products = products_response.parsed_response if products_response.success?
        erb :purchase_form
      end
    else
      @error = "Stok tidak mencukupi atau produk tidak ditemukan"
      products_response = supabase_request('GET', 'products?select=*')
      @products = products_response.parsed_response if products_response.success?
      erb :purchase_form
    end
  end

  patch '/purchases/:id/cancel' do
    # Get purchase info
    purchase_response = supabase_request('GET', "purchases?id=eq.#{params[:id]}")
    purchase = purchase_response.parsed_response.first if purchase_response.success?

    if purchase && purchase['status'] == 'completed'
      # Update purchase status
      update_data = { status: 'cancelled', cancelled_at: Time.now.iso8601 }
      response = supabase_request('PATCH', "purchases?id=eq.#{params[:id]}", update_data)
      
      if response.success?
        # Restore product stock
        product_response = supabase_request('GET', "products?id=eq.#{purchase['product_id']}")
        product = product_response.parsed_response.first if product_response.success?
        
        if product
          new_stock = product['stock'] + purchase['quantity']
          stock_update = { stock: new_stock }
          supabase_request('PATCH', "products?id=eq.#{purchase['product_id']}", stock_update)
        end
        
        json({ success: true })
      else
        json({ success: false, error: "Gagal membatalkan pembelian" })
      end
    else
      json({ success: false, error: "Pembelian tidak dapat dibatalkan" })
    end
  end

  run! if app_file == $0
end
