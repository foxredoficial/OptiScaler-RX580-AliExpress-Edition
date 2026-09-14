# OptiScaler para RX 580 (DLSS e Frame Generation)

Configuração do OptiScaler ajustada para placas AMD Polaris (RX 580, RX 570, 2048SP). 
O mod faz o jogo reconhecer a placa como compatível com DLSS e executa reconstrução neural por inteligência artificial com Frame Generation.

Já está com as correções de nitidez (RCAS) e texturas à distância (Mipmap Bias) aplicadas para evitar imagem borrada.

---

## Como usar

### 1. Registro do Windows
1. Execute o arquivo:
```
EXECUTAR_PRIMEIRO-1_Ativar_TDR_Delay_Anti_Crash.reg
```
2. Confirme e reinicie o PC. Isso ajusta o tempo de resposta do driver no Windows para a placa não congelar durante a geração de quadros.
3. *(Opcional)*: Você pode dar 2 cliques em `VERIFICAR_SISTEMA_ANTI_CRASH.bat` para confirmar se o Windows já está protegido.

### 2. Instalação ou Desinstalação no jogo
1. Feche o jogo.
2. Abra o arquivo `EXECUTAR SEGUNDO.bat`.
3. Clique em **Procurar...** e selecione o executável principal (.exe) do jogo.
   * Em jogos Unreal Engine, selecione o executável que fica na pasta `Binaries\Win64`.
4. Mantenha `dxgi.dll` e clique em **Instalar**.
   * *(Se quiser remover o mod depois, basta abrir a mesma janela e clicar em **Desinstalar**).*

### 3. No jogo
1. Abra o jogo e vá nas opções de vídeo / gráficos.
2. A opção de **NVIDIA DLSS** estará liberada. Ative em Qualidade ou Equilibrado.
3. Ative o **Frame Generation** (gerador de quadros).
4. Pressione a tecla **INSERT** no teclado para abrir o menu do mod durante o jogo, se quiser ajustar opções.

---

## Dicas importantes

* **Evitar tela piscando:** Se o jogo já tiver opção de Frame Generation no menu de opções (DLSS FG), ative **apenas pelo menu do jogo**. Não force o botão de FG no menu do mod (INSERT) ao mesmo tempo para não dar conflito. Jogue sempre em modo **Janela Sem Bordas (Borderless)**.
* **Jogos sem DLSS nativo (ex: Resident Evil 4 Remake):** Jogos que não têm suporte a DLSS de fábrica só mostram FSR no menu. Nesses jogos, basta ativar o **FSR 2** no menu do jogo; o mod vai capturar o FSR 2 e aplicar a reconstrução neural por IA automaticamente. Pressione **INSERT** dentro do jogo para confirmar que o painel abriu.

---

## Ajuste no MSI Afterburner (Opcional)

Para quem quiser extrair mais desempenho estável na RX 580:
* **Memória (Mem MHz):** Suba para 1850 MHz (aumenta bastante a fluidez em jogos pesados).
* **Clock (Core MHz):** 1260 MHz a 1300 MHz.
* Caso as opções estejam bloqueadas no Afterburner, vá nas configurações dele e ative "Desativar ULPS" e "Aumentar limites oficiais de overclock" com suporte a PowerPlay.