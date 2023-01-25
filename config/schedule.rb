every 1.day, at: '12:00 am' do
    runner 'User.reset_credits_unsubscribe'
end

every :wednesday, at: '12:00 am' do
    runner 'User.reset_credits_subscribe'
end