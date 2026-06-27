# frozen_string_literal: true

class LicenseOption
  def initialize(license)
    @license = license
  end

  def apply(gems)
    gems.select { |gem| gem.licenses.include?(@license) }
  end
end
