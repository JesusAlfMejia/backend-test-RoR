class BrandsRepresenter
  def initialize(brands)
    @brands = brands
  end

  def as_json
    brands.order(:id).map do |brand|
      {
        id: brand.id,
        name: brand.name,
        average_price: brand.average_price || 0
      }
    end
  end

  private

  attr_reader :brands
end
