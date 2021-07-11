create database getmore_challenge;

create table tb_categories (
    category_id integer  primary key,
    name varchar(128) not null
);

create table tb_products(
    product_id integer primary key,
    category_id integer not null,
    product_name varchar(128) not null,
    product_image varchar(128) not null,
    product_stock boolean not null,
    product_price numeric(15, 3) not null
);

alter table tb_products add constraint fk_tb_products_tb_categories foreign key (category_id) references tb_categories(category_id)