require 'pry'
class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
    elsif req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    else
      resp.write "Path Not Found"
    end

    #responds with empty cart message if the cart is empty
    #responds with a cart list if there is something in there
    if req.path.match(/cart/)
      if @@cart.empty? 
        resp.write "Your cart is empty"
      else
        @@cart.each do |cart|
        resp.write "#{cart}\n"
        end
      end
    end

    #Will add an item that is in the @@items list
    #Will not add an item that is not in the @@items list
    if req.path.match(/add/)
      search = req.params["item"]
      if @@items.include?(search)
        @@cart << search
        resp.write "added #{search}"
      else
        resp.write "We don't have that item"
      end
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end

end
