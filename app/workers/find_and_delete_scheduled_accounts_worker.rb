# frozen_string_literal: true

class FindAndDeleteScheduledAccountsWorker
  include Sidekiq::Job

  def perform
    return unless ThreeScale.config.onpremises
    Account.deleted_since.find_each(&DeleteAccountHierarchyWorker.method(:perform_later))
  end
end
