# Preview all emails at http://localhost:3000/rails/mailers/auth
class AuthPreview < ActionMailer::Preview
  def request_approval
    AuthMailer.request_approval(User.member.first)
  end
end
