defmodule Queue do
  # Attraverso "start" lanciamo il modulo in background, in modo che il consumer possa rimanere in ascolto di
  # eventuali messaggi.
  # funzione bypassabile chiamando spawn direttamente da riga di comando.
  def start do
    # __MODULE__ si riferisce al modulo attuale un alterego del classico this.
    # con :init ci si riferisce all'atom init che in questo caso rappresenta la nostra funzione init
    # l'ultimo valore è una mappa che viene passata come argomento ad init.
    spawn(__MODULE__, :init, [])
  end

  def init() do
    # in init possiamo inizializzare tutti i dati che vogliamo in questo caso passiamo subito al lancio di
    # messageLogger che a sua volta richiamera se stesso per rimanere sempre in ascolto
    pid = self();
    consumer(pid)
  end

  def consumer(pid) do
    # Il consumer resta in ascolto dei messaggi ed eventualmente crea processi Mailer per soddisfare le richieste
    receive do
      {:send, emails} ->
        Enum.map(emails, &spawn(Mailer, :sendMail, [&1, pid]))

      {:done, email, tempo} ->
        IO.puts "eMail inviata a #{email} alle ore #{tempo}"
    end
    consumer(pid)
  end
end
