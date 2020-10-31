require 'mysql2'
require './item.rb'
require './category.rb'

def create_db_client
    client = Mysql2::Client.new(
        :host => '127.0.0.1',
        :username => 'your username',
        :password => 'your password',
        :database => 'your food database'
    )
    client
end

def get_all_items
    client = create_db_client
    raw_data = client.query("SELECT * FROM ITEMS ORDER BY ID DESC")
    items =  Array.new
    raw_data.each do |data|
        item = Item.new(data['name'], data['price'], data['id'])
        items.push(item)
    end
    items
end

def get_all_categories
    client = create_db_client
    raw_data = client.query("SELECT * FROM CATEGORIES ORDER BY ID ASC")
    categories = Array.new
    raw_data.each do |data|
        category = Category.new(data['name'], data['id'])
        categories.push(category)
    end
    categories
end

def get_item_details(item_id)
    query = "select i.name, i.price, i.id, c.name category 
            from items i 
            join item_categories ic 
                on i.id = ic.item_id 
            join categories c 
                on c.id = ic.category_id 
            where i.id = #{item_id}
            order by i.id"
    client = create_db_client
    raw_data = client.query(query)
    item_details = Array.new
    raw_data.each do |data|
        item = Item.new(data['name'], data['price'], data['id'], data['category'])
        item_details.push(item)
    end
    item_details
end

def get_items_by_price(price)
    query = "select i.name item_name, 
                    c.name categories, 
                    i.price
            from items i 
            join item_categories ic 
                on i.id = ic.item_id 
            join categories c 
                on c.id = ic.category_id 
            where i.price < #{price}
            order by i.id"
    client = create_db_client
    client.query(query)
end

def create_new_item(name, price, category_id)
    client = create_db_client
    client.query("insert into items(name, price) values('#{name}', '#{price}')")
    client.query("insert into item_categories(item_id, category_id) 
                select id , #{category_id}
                from items 
                where name = '#{name}'
    ")
end

def update_item(name, price, category_id, food_id)
    client = create_db_client
    client.query("  update items 
                    set name = \"#{name}\",
                        price = #{price}
                    where id = #{food_id}")
    client.query("  update item_categories
                    set category_id = #{category_id}
                    where item_id = #{food_id}")
end

def drop_item(food_id)
    client = create_db_client
    client.query("delete from item_categories where item_id = #{food_id}")
    client.query("delete from items where id = #{food_id}")
end