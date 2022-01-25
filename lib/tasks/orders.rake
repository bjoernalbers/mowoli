namespace :orders do
  desc 'Purge expired orders'
  task purge_expired: [:environment] do
    Order.purge_expired
  end
end
