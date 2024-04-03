module EmailHelper
  def extract_reset_password_link_from_email(email)
    body = email.body.raw_source
    links = URI.extract(body)
    links.find { |link| link.include?('password/edit') }
  end
end
