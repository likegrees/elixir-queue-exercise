defmodule Mailer do
  def sendMail(email, fatherPid) do
    # simulazione di invio mail
    :timer.sleep(1000)
    # invio messaggio riuscito
    send(fatherPid, {:done, email, DateTime.to_string(DateTime.utc_now)})
  end
end
