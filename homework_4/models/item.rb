require './db/db_connector.rb'
# require_relative 'category.rb'
# require '../db/db_connector.rb'

class Item
    attr_accessor :name, :price, :id, :categories

    def initialize(params)
        @name = params[:name]
        @price = params[:price]
        @id = params[:id]
        @categories = params[:categories]
    end

    def save
        return false unless valid?

        client = create_db_client
        client.query("insert into items(name, price) values('#{name}', #{price}) ")
        categories.each do |category|
            category = category.to_i
            query = "insert into item_categories(item_id, category_id) 
                    select id , #{category} 
                    from items 
                    where name = '#{name}'"
            client.query(query)
        end
    end

    def valid?
        return false if @name.nil?
        return false if @price.nil?
        true
    end

    def self.get_all_items
        client = create_db_client
        raw_data = client.query("SELECT * FROM ITEMS ORDER BY ID DESC")
        items = Array.new
        raw_data.each do |data|
            item = Item.new(
                name: data['name'], 
                price: data['price'], 
                id: data['id'])
            items.push(item)
        end
        items
    end

    def self.get_item_by_id_for_food_details(item_id)
        query = "select i.name, i.price, i.id, group_concat(c.name) categories 
                from items i 
                left join item_categories ic 
                    on i.id = ic.item_id 
                left join categories c 
                    on c.id = ic.category_id 
                where i.id = #{item_id}
                order by i.id"
        client = create_db_client
        raw_data = client.query(query)

        item_details = Array.new
        raw_data.each do |data|
            item = Item.new({
                name: data['name'], 
                price: data['price'], 
                id: data['id'], 
                categories: data['categories']})
            item_details.push(item)
        end
        item_details
    end

    def self.get_item_by_id_for_edit_food(item_id)
        q_item = "
                select i.name, i.price, i.id
                from items i 
                where i.id = #{item_id}
                order by i.id
        "
        client = create_db_client
        item_raw_data = client.query(q_item)

        q_item_category = "
                select c.name
                from item_categories ic
                join categories c
                    on ic.category_id = c.id
                where item_id = #{item_id}
                order by c.id 
        "
        client = create_db_client
        category_raw_data = client.query(q_item_category)

        item_categories = Array.new
        item_details = Array.new
        item_raw_data.each do |data|
            category_raw_data.each do |category|
                item_categories << category['name']
            end
            item = Item.new({
                name: data['name'], 
                price: data['price'], 
                id: data['id'],
                categories: item_categories
            })
            item_details.push(item)
        end
        item_details
    end

    def self.update_item(food_id, name, price, category_id)
        client = create_db_client
        client.query("  update items 
                        set name = \"#{name}\",
                            price = #{price}
                        where id = #{food_id}")

        current_categories = Item.get_item_categories_id_by_id(food_id)
        category_id.each do |id|
            id=id.to_i
            if !current_categories.include?(id)
                client.query("insert into item_categories(item_id,category_id) values(#{food_id}, #{id})")
            end
        end
        current_categories.each do |category|
            category = "#{category}"
            if !category_id.include?(category)
                client.query("delete from item_categories 
                            where item_id = #{food_id} 
                            and category_id = #{category}"
                            )
            end
        end
    end

    def self.get_item_categories_id_by_id(item_id)
        client = create_db_client
        raw_data = client.query("
            select c.id
            from item_categories ic
            join categories c
                on ic.category_id = c.id
            where item_id = #{item_id}
            order by c.id
        ")
        current_categories = []
        raw_data.each do |data| 
            current_categories << data['id']
        end
        current_categories
    end

    def self.drop_item(food_id)
        client = create_db_client
        client.query("delete from item_categories where item_id = #{food_id}")
        client.query("delete from items where id = #{food_id}")
    end
end

# params = {
#     name: 'Chocolate Milk Shake',
#     price: 25000,
#     category: 2
# }
# item = Item.new(params)
# result = Item.get_item_by_id_for_food_details(1)
# puts "#{result}"
# result = Item.get_all_items_related_by_category_id(1)
# puts "#{result}"