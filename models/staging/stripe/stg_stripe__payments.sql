select
    "ID" as payment_id,
    "ORDERID" as order_id,
    "AMOUNT" / 100 as amount,
    "CREATED" as created_date,
    "PAYMENTMETHOD" as payment_method,
    "STATUS" as status

from public.stripe_payments
where "STATUS" = 'success'
