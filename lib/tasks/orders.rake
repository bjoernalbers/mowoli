require 'dotenv/tasks'

namespace :orders do
  desc 'Purge expired orders'
  task purge_expired: [:environment, :dotenv] do
    Order.purge_expired
  end
end
