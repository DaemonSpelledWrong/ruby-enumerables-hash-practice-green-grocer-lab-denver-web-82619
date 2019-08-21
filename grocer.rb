def consolidate_cart(cart)
  organized_cart = {}                   # New hash to store organized items
  cart.each do |element|
    element.each do |key, value|
      organized_cart[key] ||= value     # If the key doesn't exist in organized_cart, instantiate as a                                   # a key : value pair matching what was passed in
      organized_cart[key][:count] ||= 0 # If the key :count exists, continue, otherwise instantiate with 
                                        # a key : value pair of :count => 0
      organized_cart[key][:count] += 1  # If another key with an already existing :count key exists,
                                        # increment the count
    end
  end
  return organized_cart                 # Return the newly organized cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon_hash|
    coupon.each do |a, value|
      n = coupon_hash[:item]
      if cart[n] && cart[n][:count] >= coupon_hash[:num] 
        if cart["#{n} W/COUPON"]
          cart["#{n} W/COUPON"][:count] += coupon_hash[:num]
        else
          cart["#{n} W/COUPON"] = {
            :price => coupon_hash[:cost] / coupon_hash[:num],
            :clearance => cart[n][:clearance],
            :count => coupon_hash[:num] }
        end
        cart[n][:count] -= coupon_hash[:num] 
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, properties|
    if properties[:clearance] == true                          # If the item has a clearance key value of                                                          # true, continue down
      properties[:price] = (properties[:price] * 0.8).round(2) # Price key val is changed to 80% rounded
                                                               # to account for clearance 20% off
    end
  end
  cart                                                         #Return clearance applied cart
end

def checkout(items, coupons)
  # Create a cart variable that has all three methods above applied
  cart = apply_clearance(apply_coupons(consolidate_cart(items), coupons))
  
  total = 0                                 # Customer total starts at 0, then adds price per item below
  
  cart.each do |name, properties|
    total += properties[:price] * properties[:count]
  end
  
  total > 100 ? total * 0.9 : total         # Apply the store discount for totals over $100
  
end
