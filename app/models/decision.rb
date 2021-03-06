# == Schema Information
#
# Table name: decisions
#
#  id               :bigint           not null, primary key
#  assessment_type  :string
#  extension_date   :date
#  module_code      :string
#  requested_action :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  agenda_id        :integer
#  outcome_id       :string
#

# This relates a decision to an agenda.
# Each decision will have an outcome.
class Decision < ApplicationRecord
  belongs_to :agenda
  belongs_to :outcome
end
