connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: case_studies_vk_default_datagroup {
  sql_trigger: SELECT count(*) FROM order_items;;
  max_cache_age: "24 hours"
}

persist_with: case_studies_vk_default_datagroup

#-------------------- ORDER ITEMS ----------------------

explore: order_items {
  persist_with: case_studies_vk_default_datagroup

  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
  label: "Customers"
}
