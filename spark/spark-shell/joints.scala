/**explore cloudera provided DataCo dataset in mysql
 * mysql -u retail_dba -p cloudera
 * use retail_db;
 * show tables;
 * +---------------------+
 * | Tables_in_retail_db |
 * +---------------------+
 * | categories          |
 * | customers           |
 * | departments         |
 * | order_items         |
 * | orders              |
 * | products            |
 * +---------------------+
 * 
 * desc orders;
 * +-------------------+-------------+------+-----+---------+----------------+
 * | Field             | Type        | Null | Key | Default | Extra          |
 * +-------------------+-------------+------+-----+---------+----------------+
 * | order_id          | int(11)     | NO   | PRI | NULL    | auto_increment |
 * | order_date        | datetime    | NO   |     | NULL    |                |
 * | order_customer_id | int(11)     | NO   |     | NULL    |                |
 * | order_status      | varchar(45) | NO   |     | NULL    |                |
 * +-------------------+-------------+------+-----+---------+----------------+
 * 
 * desc order_items;
 * +--------------------------+------------+------+-----+---------+----------------+
 * | Field                    | Type       | Null | Key | Default | Extra          |
 * +--------------------------+------------+------+-----+---------+----------------+
 * | order_item_id            | int(11)    | NO   | PRI | NULL    | auto_increment |
 * | order_item_order_id      | int(11)    | NO   |     | NULL    |                |
 * | order_item_product_id    | int(11)    | NO   |     | NULL    |                |
 * | order_item_quantity      | tinyint(4) | NO   |     | NULL    |                |
 * | order_item_subtotal      | float      | NO   |     | NULL    |                |
 * | order_item_product_price | float      | NO   |     | NULL    |                |
 * +--------------------------+------------+------+-----+---------+----------------+
 * 
 * join orders and order_items, get order count and revenue per day
 */
 
 
