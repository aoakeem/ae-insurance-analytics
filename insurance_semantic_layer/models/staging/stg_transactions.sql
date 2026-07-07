with

source as (

    select * from {{ source('insurance', 'raw_transactions_2hr') }}

),

renamed as (

    select
        cast(transaction_id      as integer)        as transaction_id,
        cast(policy_id           as integer)        as policy_id,

        cast(transaction_type    as varchar)        as transaction_type,
        cast(transaction_status  as varchar)        as transaction_status,

        cast(transaction_amount  as decimal(18, 2)) as transaction_amount,

        cast(transaction_date    as date)           as transaction_date

    from source

)

select * from renamed
