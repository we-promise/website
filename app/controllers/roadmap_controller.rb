class RoadmapController < ApplicationController
  layout "application"

  def show
    @phases = Rails.cache.fetch("roadmap/phases", expires_in: 24.hours) do
      RoadmapParser.new.parse
    end
    @items = @phases.flat_map { |phase| phase[:items] }
    @status_counts = @items.group_by { |item| item[:status] }.transform_values(&:count)
  end
end
