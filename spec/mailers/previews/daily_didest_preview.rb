# Preview all emails at http://localhost:3000/rails/mailers/daily_didest
class DailyDidestPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/daily_didest/digest
  def digest
    DailyDidestMailer.digest
  end

end
