class BidNotificationWorker
  include Sidekiq::Worker

  def perform(lot_id, last_bid_id, new_bid_id)
    lot = Lot.find(lot_id)

    bid = Bid.find_by(id: new_bid_id)
    prev_bid = Bid.find_by(id: last_bid_id)

    return if bid.blank?

    user_beaten = prev_bid.user
    return if user_beaten.blank?

    BidMailer.new_bid_email(user_beaten, lot, bid.amount).deliver_now
  end
end
