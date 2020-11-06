require './db/db_connector.rb'
require_relative 'item.rb'
# require '../db/db_connector.rb'

class Category
    attr_accessor :name, :id, :items
    
    def initialize(params)
        @name = params[:name]
        @id = params[:id]
        @items = params[:items]
    end

    def save
        return false unless valid?

        client = create_db_client
        client.query("INSERT INTO CATEGORIES(NAME) VALUES('#{name}')")
    end

    def valid?
        return false if @name.nil?
        true
    end

    def self.get_all_categories
        client = create_db_client
        raw_data = client.query("SELECT * FROM CATEGORIES ORDER BY ID DESC")
        categories =  Array.new
        raw_data.each do |data|
            category = Category.new(
                name: data['name'], 
                id: data['id'])
            categories.push(category)
        end
         categories
    end

    def self.get_category_detail_by_category_id(id)
        client = create_db_client

        query = "
            SELECT C.ID, C.NAME, COUNT(IC.ITEM_ID) ITEMS_INCLUDED
            FROM CATEGORIES  C
            LEFT JOIN ITEM_CATEGORIES IC
                ON C.ID = IC.CATEGORY_ID
            WHERE ID = #{id}
            GROUP BY C.ID, C.NAME
        "
        raw_data = client.query(query)

        categories =  Array.new
        raw_data.each do |data|
            category = Category.new({
                name: data['NAME'], 
                id: data['ID'],
                items: data['ITEMS_INCLUDED']
            })
            categories.push(category)
        end
        categories
    end

    def self.get_all_items_related_by_category_id(id)
        query = "SELECT I.NAME , I.PRICE, I.ID 
                FROM ITEM_CATEGORIES IC
                JOIN ITEMS I
                    ON I.ID = IC.ITEM_ID 
                WHERE IC.CATEGORY_ID = #{id}"
        client = create_db_client
        raw_data = client.query(query)

        items_related = Array.new
        raw_data.each do |data|
            item = Item.new({
                name: data['NAME'], 
                price: data['PRICE'], 
                id: data['ID']})
            items_related.push(item)
        end
        items_related
    end

    def self.update_category(category_id, category_name)
        client = create_db_client
        client.query("UPDATE CATEGORIES SET NAME = '#{category_name}' WHERE ID = #{category_id}")
    end

    def self.drop_category(category_id)
        client = create_db_client
        q_delete_relation_with_items = "
            DELETE FROM ITEM_CATEGORIES WHERE CATEGORY_ID = #{category_id}
        "
        q_delete_category = "
            DELETE FROM CATEGORIES WHERE ID = #{category_id}
        "
        client.query(q_delete_relation_with_items)
        client.query(q_delete_category)
    end

end

# result = Category.get_category_detail_by_category_id(4)
# puts "#{result}"