module ApplicationHelper
  def form_url_builder(record, opts = {})
    opts[:controller] = record.class.name.tableize
    opts[:action] = 'create'

    if record&.id
      opts[:action] = 'update'
      opts[:id] = record.id
    end
    url_for(opts)
  end

  def form_option_builder(record, params = {})
    {
      url: form_url_builder(record, params),
      method: record&.id ? 'PATCH' : 'POST'
    }
  end

  # link back to custom path
  def back_to(path)
    link_to('<i class="fa-solid fa-arrow-left"></i>'.html_safe, path, class: 'text-secondary ms-2')
  end
end
