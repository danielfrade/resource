# Gerenciador Inteligente de Recursos com PowerShell  

Um script inovador em PowerShell para monitoramento, análise preditiva e automação de recursos do sistema! O **Gerenciador Inteligente de Recursos** detecta problemas de desempenho em tempo real, sugere soluções práticas e as implementa com aprovação do usuário, além de gerar relatórios visuais em HTML. Perfeito para administradores de sistemas que buscam eficiência e controle.

## Funcionalidades do Script  
- **Monitoramento em Tempo Real**: Coleta dados de CPU, memória e disco, exibindo gráficos ASCII simples no console.  
- **Análise Preditiva Simples**: Identifica tendências com base em thresholds e sugere ações preventivas.  
- **Automação Interativa**: Propõe soluções como finalizar processos, liberar memória ou limpar disco, executando apenas após confirmação do usuário.  
- **Relatório Visual em HTML**: Gera relatórios estilizados com cores (vermelho para crítico, laranja para alerta, verde para normal), abertos automaticamente no navegador.  
- **Gráficos ASCII**: Visualização direta no console para uma experiência prática e funcional.

## Benefícios  
- **Proatividade**: Antecipe problemas com análise preditiva básica e sugestões inteligentes.  
- **Eficiência**: Automatize tarefas repetitivas com segurança e controle total do usuário.  
- **Clareza Visual**: Relatórios em HTML e gráficos ASCII facilitam a análise rápida do sistema.  
- **Flexibilidade**: Ideal para uso em estações de trabalho ou servidores, com adaptação simples.  
- **Leveza**: Não depende de ferramentas externas complexas, apenas do PowerShell nativo.

## Pré-requisitos  
- **PowerShell**: Versão 5.1 ou superior (padrão no Windows).  
- **Permissões**: Execute como administrador para ações como finalizar processos ou limpar disco.  
- **Navegador Padrão**: Necessário para visualizar o relatório HTML gerado automaticamente.

## Como Usar  

### Clonando o Repositório  
1. Clone este repositório:  
   ```bash
   git clone https://github.com/[seu-usuario]/ResourceManager.git
   ```  

### Executando o Script  
1. Abra o PowerShell como administrador.  
2. Navegue até o diretório do script:  
   ```powershell
   cd caminho\para\ResourceManager
   ```  
3. Execute o script:  
   ```powershell
   .\ResourceManager.ps1
   ```  
4. Siga as instruções interativas para monitorar, analisar ou automatizar ações no sistema.

## Estrutura do Projeto  
- `ResourceManager.ps1`: Script principal com todas as funcionalidades.  
- `README.md`: Documentação detalhada do projeto.  

## Exemplos de Uso  
- **Monitorar Recursos**: Inicie o script e veja em tempo real o uso de CPU, memória e disco com gráficos ASCII.  
- **Receber Sugestões**: Se o uso de memória atingir 90%, o script sugere liberar recursos e aguarda sua aprovação.  
- **Gerar Relatório**: Após o monitoramento, exporte um relatório HTML com o status do sistema em cores para análise detalhada.

## Contribuindo  
Contribuições são bem-vindas! Siga os passos abaixo:  
1. Faça um fork do projeto.  
2. Crie uma branch para sua melhoria:  
   ```bash
   git checkout -b feature/nova-funcionalidade
   ```  
3. Commit suas mudanças:  
   ```bash
   git commit -m 'Adicionando nova funcionalidade'
   ```  
4. Faça push para a branch:  
   ```bash
   git push origin feature/nova-funcionalidade
   ```  
5. Abra um Pull Request.  

## Notas  
- **Personalização**: Ajuste os thresholds de análise preditiva no código para atender às suas necessidades.  
- **Performance**: Em sistemas com muitos processos, o monitoramento pode exigir ajustes para evitar sobrecarga.  
- **Segurança**: Teste em um ambiente controlado antes de usar em produção, especialmente para ações automatizadas.

Eleve o gerenciamento de recursos do seu sistema com automação inteligente e visualização prática! 🚀
