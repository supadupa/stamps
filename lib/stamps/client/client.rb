module Stamps
  class Client
    # This is supposed to be send from the client as a unique identifier-
    # seems like UUIDs arnen't working after all although the docs say that
    # they accept a string... going for a string of numbers now
    #
    def generate_transaction_id
      Time.now.strftime("%m%d%Y%I%M%S")
    end
  end
end
