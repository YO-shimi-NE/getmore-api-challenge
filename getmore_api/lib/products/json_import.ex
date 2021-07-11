defmodule Products.JsonImport do
  def import_categories do
    {:ok, itens} = load_json()

    itens
    |> Enum.map(fn %{productCategory: category_name} -> category_name end)
    |> Enum.uniq()
    |> insert_categories()
  end

  def import_products do
    {:ok, itens} = load_json()

    itens
    |> insert_products()
  end

  defp load_json do
    File.read("../products.json")
    |> convert_json_map
  end

  defp convert_json_map({:ok, content}), do: Jason.decode(content, keys: :atoms)

  defp init_connection do
    Postgrex.start_link(
      hostname: "localhost",
      username: "postgres",
      password: "postgres",
      database: "getmore_challenge"
    )
  end

  defp insert_categories(categories) do
    {:ok, pid} = init_connection()

    Enum.map(categories, fn name ->
      Postgrex.query!(pid, "insert into tb_categories (name) values ($1)", [name])
    end)

    Process.exit(pid, :normal)
  end

  defp insert_products(products) do
    {:ok, pid} = init_connection()

    Enum.map(products, fn item ->
      Postgrex.query!(
        pid,
        "insert into tb_products" <>
          "(product_id, category_id, product_name, product_image, product_stock, product_price)" <>
          " values " <>
          "($1, (select category_id from tb_categories where name like $2 LIMIT 1), $3, $4, $5, $6::text::float);",
        [
          item.productId,
          item.productCategory,
          item.productName,
          item.productImage,
          item.productStock,
          item.productPrice
        ]
      )
    end)

    Process.exit(pid, :normal)
  end
end
