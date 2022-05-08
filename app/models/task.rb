class Task < ApplicationRecord
    after_initialize :set_defaults, unless: :persisted?
    # The set_defaults will only work if the object is new

    def set_defaults
        self.status ||= 1
    end
    validates :name, presence: true
    validates :description, presence: true
    validates :priority, presence: true
end
