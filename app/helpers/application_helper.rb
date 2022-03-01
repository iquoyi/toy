module ApplicationHelper
  def form_url_builder(record)
    options = {
      controller: record.class.name.tableize,
      action: 'create'
    }
    if record&.id
      options[:action] = 'update'
      options[:id] = record.id
    end
    url_for(options)
  end

  def form_option_builder(record)
    {
      url: form_url_builder(record),
      method: record&.id ? 'PATCH' : 'POST'
    }
  end
end
