class Admin::EffectiveResponsesDatatable < Effective::Datatable
  datatable do
    col :updated_at, visible: false
    col :created_at, visible: false
    col :id, visible: false

    col :responsable
    col :questionable
    col :question

    col(:response) do |response|
      render('effective/responses/response', response: response)
    end

    col :correct?, as: :boolean

    actions_col
  end

  collection do
    Effective::Response.all.deep
  end

end
