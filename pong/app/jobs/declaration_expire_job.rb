class DeclarationExpireJob < ApplicationJob
  queue_as :default

  def perform(declaration_id)
    return if Declaration.where(id: declaration_id).empty?

    Declaration.where(id: declaration_id).first!.destroy!
  end
end
