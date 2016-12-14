class Application

  require 'pry'
  @@items = []
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)

    if req.path.match(/search/)
      search_term = req.params["q"]
      resp.write handle_search(search_term)
    elsif req.path.match(/cart/)
      resp.write handle_cart
    elsif req.path.match(/add/)
      item = req.params["item"]
      if @@items.include?(item)
        @@cart << item
        resp.write "added #{item}"
      else
        resp.write "We don't have that item"
      end
    elsif req.path.match(/items/)
      item_name = req.path.split("/items/").last 
      item = @@items.find { |item| item.name.downcase == item_name.downcase }
      if item != nil 
        resp.write "#{item.price}"
      else
        resp.status = 400
        resp.write "Item not found"
      end
    else
      resp.write "Route not found"
      resp.status = 404
    end

    resp.finish
  end

  # def handle_search(search_term)
  #   if @@items.include?(search_term)
  #     return "#{search_term} is one of our items"
  #   else
  #     return "Couldn't find #{search_term}"
  #   end
  # end

  # def handle_cart
  #   if @@cart.empty?
  #     "Your cart is empty"
  #   else
  #     @@cart.collect do |item|
  #       "#{item}\n"
  #     end.join
  #   end
  # end

end
