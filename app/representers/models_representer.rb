class ModelsRepresenter
  def initialize(models)
    @models = models
  end

  def as_json
    models.order(:name).map do |model|
      {
        id: model.id,
        name: model.name,
        average_price: model.average_price
      }
    end
  end

  private

  attr_reader :models
end
