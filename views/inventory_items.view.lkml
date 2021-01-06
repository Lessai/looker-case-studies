view: inventory_items {
  sql_table_name: "PUBLIC"."INVENTORY_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: product_distribution_center_id {
    type: number
    hidden: yes
    sql: ${TABLE}."PRODUCT_DISTRIBUTION_CENTER_ID" ;;
  }

  dimension: product_id {
    type: number
    hidden: yes
    sql: ${TABLE}."PRODUCT_ID" ;;
  }

#----------------- Product Info -----------------#

  dimension: product_brand {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}."PRODUCT_BRAND" ;;
  }

  dimension: product_category {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}."PRODUCT_CATEGORY" ;;
  }

  dimension: product_department {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}."PRODUCT_DEPARTMENT" ;;
  }

  dimension: product_name {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}."PRODUCT_NAME" ;;
  }

  dimension: product_sku {
    group_label: "Product Info"
    type: string
    sql: ${TABLE}."PRODUCT_SKU" ;;
  }

#--------------------------------------------------#

  dimension: cost {
    type: number
    sql: ${TABLE}."COST" ;;
  }

  dimension: product_retail_price {
    type: number
    sql: ${TABLE}."PRODUCT_RETAIL_PRICE" ;;
  }


  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SOLD_AT" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }


  #-----------------------MEASURES--------------------#
  measure: count {
    hidden: yes
    type: count
    drill_fields: [id, product_name, products.id, products.name, order_items.count]
  }

  measure: total_cost{
    description: "Total cost of items sold from inventory"
    type: sum
    value_format_name: usd
    sql: ${cost} ;;
  }
}
