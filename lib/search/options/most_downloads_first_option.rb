# frozen_string_literal: true

class MostDownloadsFirstOption
  def apply(gems)
    gems.sort_by { |gem| -gem.downloads }
  end
end
