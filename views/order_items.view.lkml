view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
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

  dimension_group: delivered {
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
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
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
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
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
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: is_yesterday {
    type: yesno
    sql:  ${created_raw} == DATEADD(Day ,-1, current_date) ;;
  }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

#------------------------- METRICS -----------------------------#

  measure: total_sale_price {
    description: "Total sales from items sold"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: average_sale_price {
    description: "Average sale price of items sold"
    type: average
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: cumulative_total_sales {
    description: "Cumulative total sales from items sold (also known as a running total)"
    type: running_total
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: total_gross_revenue {
    description: "Total revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: [status: "-cancelled , -returned"]
  }

  measure: total_gross_margin {
    description: "Total difference between the total revenue from completed sales and the cost of the goods that were sold"
    type:  number
    value_format_name: usd
    sql:  ${total_gross_revenue} - ${inventory_items.total_cost} ;;
  }

  measure: gross_margin_percent {
    description: "Total Gross Margin Amount / Total Gross Revenue"
    type:  number
    value_format_name: percent_1
    sql: ${total_gross_margin} / ${total_gross_revenue} ;;
  }

  measure: average_gross_margin {
    description: "Average difference between the total revenue from completed sales and the cost of the goods that were sold"
    type: average
    value_format_name: usd
    sql: ${sale_price} - ${inventory_items.cost} ;;
    filters: [status: "-cancelled , -returned"]
    }

  measure: number_of_items_returned {
    description: "Number of items that were returned by dissatisfied customers"
    type: count
    filters: [status: "returned"]
  }

  measure: item_return_rate {
    description: "Number of Items Returned / total number of items sold"
    type: number
    value_format_name: percent_1
    sql: ${number_of_items_returned}/${count} ;;
  }

  measure: number_of_customers_returning_items {
    description: "Number of users who have returned an item at some point"
    type:  count_distinct
    sql: ${user_id} ;;
    filters: [status: "returned"]
  }

  measure: total_number_of_customers{
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: percent_of_users_with_returns {
    type: number
    value_format_name: percent_1
    sql: ${number_of_customers_returning_items}/${total_number_of_customers};;
  }

  measure: average_spend_per_customer {
    type: number
    value_format_name: usd
    sql: ${total_sale_price}/${total_number_of_customers} ;;
  }

  measure: total_revenue_yesterday {
    description: "Total yesterday's revenue from completed sales (cancelled and returned orders excluded)"
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
    filters: [status: "-cancelled , -returned", is_yesterday: "yes"]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.first_name,
      users.last_name,
      users.id,
      inventory_items.product_name,
      inventory_items.id
    ]
  }
}
