O comportamento ao editar ficou semelhante a um formulário inline: ao sair do campo ou pressionar "enter", o valor é validado e enviado.
Foi adaptado o widget TransactionCardSheets para que os campos title, amount e date de cada transação fossem editáveis com TextField 
onUpdate foi adicionado ao TransactionCardSheets, permitindo que o widget envie a transação para o controller
No HomePageController, foi criado um novo Command1 chamado updateTransaction, responsável por:
Enviar a transação editada ao caso de uso (UpdateTransactionUseCaseImpl)
Atualizar a lista interna _transactions para refletir a modificação na tela
O UpdateTransactionUseCaseImpl foi implementado para repassar a transação editada ao repositório.
Foi registrado no setupDependencies() para que o TransactionFacadeUseCases pudesse usá-lo.
No HomeScreen, o parâmetro onUpdate foi conectado ao comando updateTransaction.execute(...).

Ao alterar título, valor ou data de transação:
interface reflete a mudança; O dado é persistido pelo repositório fake e a arquitetura padrão é respeitada.
