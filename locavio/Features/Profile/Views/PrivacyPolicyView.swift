//
//  PrivacyPolicyView.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 29/09/26.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            
            Color.appBg
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Última atualização: 25 de setembro de 2026")
                        .foregroundStyle(.secondary)
                    
                    Text("Esta Política de Privacidade descreve como o Locavio coleta, usa, armazena e protege os dados pessoais dos usuários (proprietários de imóveis) e de terceiros cujos dados sejam inseridos no aplicativo (inquilinos), em conformidade com a Lei Geral de Proteção de Dados (Lei nº 13.709/2018 — LGPD).")
                    
                    sectionTitle("1. Interpretação e Definições")
                    
                    subsectionTitle("1.1 Definições")
                    
                    Text("Para os fins desta Política de Privacidade:")
                    
                    ListCardComponent(textList: definitions)
                    
                    sectionTitle("2. Coleta e Uso de Suas Informações Pessoais")
                    
                    subsectionTitle("2.1 Dados Pessoais")
                    
                    Text("Ao utilizar o nosso Serviço, poderemos solicitar que você nos forneça determinadas informações de identificação pessoal que possam ser usadas para entrar em contato ou identificá-lo. As informações de identificação pessoal podem incluir, entre outras:")
                    
                    ListCardComponent(textList: personalData)
                    
                    subsectionTitle("2.2 Uso dos Seus Dados Pessoais")
                    
                    Text("A Empresa poderá utilizar os Dados Pessoais para as seguintes finalidades:")
                    
                    ListCardComponent(textList: dataUsage)
                    
                    Text("Podemos compartilhar seus Dados Pessoais nas seguintes situações:")
                    
                    ListCardComponent(textList: dataSharing)
                    
                    sectionTitle("3 Dados de Terceiros (Inquilinos)")
                    
                    Text("Ao cadastrar um imóvel ou contrato, Você poderá inserir Dados Pessoais de terceiros (inquilinos), como nome, contato, CPF e histórico de pagamento. Nesse caso:")
                    
                    ListCardComponent(textList: thirdPartyData)
                    
                    sectionTitle("4 Armazenamento dos Dados — iCloud e CloudKit")
                    
                    Text("Os dados inseridos no Aplicativo são armazenados por meio dos serviços **iCloud** e **CloudKit**, da Apple Inc., que atua como Operadora dos dados em nosso nome. Isso significa que:")
                    
                    ListCardComponent(textList: storage)
                    
                    sectionTitle("5 Retenção dos Seus Dados Pessoais")
                    
                    Text("Mantemos seus dados pessoais apenas pelo tempo necessário para as finalidades descritas nesta Política. Ao encerrar sua Conta, seus dados pessoais são excluídos imediatamente da nossa base de dados ativa.")
                    
                    Text("Essa exclusão está sujeita a limitações técnicas de infraestrutura: cópias de segurança mantidas pela Apple (iCloud/CloudKit) seguem as políticas próprias de retenção da Apple e podem não ser removidas de forma instantânea de todos os sistemas de backup e replicação.")
                    
                    Text("A exclusão da Conta é definitiva e não pode ser desfeita. Recomendamos que você mantenha suas próprias cópias de documentos, contratos e comprovantes armazenados no aplicativo antes de solicitar o encerramento.")
                    
                    sectionTitle("6 Seus Direitos como Titular de Dados")
                    
                    Text("Nos termos do art. 18 da LGPD, você tem direito a:")
                    
                    ListCardComponent(textList: dataSubjectRights)
                    
                    Text("Para exercer qualquer um desses direitos, entre em contato conosco pelos canais indicados abaixo.")
                    
                    sectionTitle("7 Transferência dos Seus Dados Pessoais")
                    
                    Text("Como os dados são armazenados via iCloud/CloudKit, é possível que sejam transferidos para e mantidos em servidores localizados fora do Brasil. Quando isso ocorrer, adotaremos as salvaguardas exigidas pela LGPD (art. 33), como cláusulas contratuais e garantias de proteção equivalentes às exigidas na legislação brasileira.")
                    
                    sectionTitle("8 Exclusão dos Seus Dados Pessoais")
                    
                    Text("Você tem o direito de excluir ou solicitar que nós o ajudemos a excluir os Dados Pessoais que coletamos \nsobre Você.")
                    
                    Text("O nosso Serviço pode lhe dar a possibilidade de excluir determinadas informações sobre você diretamente \npelo Serviço.")
                    
                    Text("Você pode atualizar, corrigir ou excluir suas informações a qualquer momento, acessando sua conta, caso possua uma, e acessando a seção de configurações de conta que permite gerenciar suas informações pessoais. Você também pode entrar em contato conosco para solicitar acesso, correção ou exclusão de quaisquer Dados Pessoais que Você tenha nos fornecido.")
                    
                    Text("Observe, no entanto, que podemos precisar reter determinadas informações quando tivermos uma obrigação legal ou base legal para tanto.")
                    
                    sectionTitle("9 Divulgação dos Seus Dados Pessoais")
                    
                    subsubsectionTitle("9.1 Autoridades Policiais")
                    
                    Text("Em certas circunstâncias, a Empresa poderá divulgar seus Dados Pessoais se exigido por lei ou em resposta a solicitações válidas de autoridades públicas (por exemplo, um tribunal ou órgão governamental).")
                    
                    subsubsectionTitle("9.2 Outras Exigências Legais")
                    
                    Text("A Empresa poderá divulgar seus Dados Pessoais na crença de boa-fé de que tal ação é necessária para:")
                    
                    ListCardComponent(textList: legalRequirements)
                    
                    sectionTitle("10 Segurança dos Seus Dados Pessoais")
                    
                    Text("Adotamos medidas técnicas e administrativas razoáveis para proteger seus Dados Pessoais, incluindo a criptografia oferecida pela infraestrutura do iCloud/CloudKit. Ainda assim, nenhum método de transmissão pela internet ou armazenamento eletrônico é 100% seguro, e não podemos garantir segurança absoluta.")
                    
                    sectionTitle("11 Notificação de Incidentes de Segurança")
                    
                    Text("Em caso de incidente de segurança que possa acarretar risco ou dano relevante aos titulares, comunicaremos a Autoridade Nacional de Proteção de Dados (ANPD) e os titulares afetados, conforme exigido pelo art. 48 da LGPD, informando a natureza dos dados afetados, as medidas técnicas adotadas e as providências tomadas para reverter ou mitigar os efeitos do incidente.")
                    
                    sectionTitle("12. Privacidade de Crianças e Menores")
                    
                    Text("O Aplicativo é destinado a proprietários de imóveis maiores de 18 anos, idade mínima para celebrar contratos de locação no Brasil. Não coletamos intencionalmente dados de menores de idade. Caso identifiquemos Dados Pessoais de um menor cadastrados indevidamente, tomaremos as medidas necessárias para excluí-los.")
                    
                    sectionTitle("13. Alterações a esta Política de Privacidade")
                    
                    Text("Podemos atualizar nossa Política de Privacidade periodicamente. Notificaremos você sobre quaisquer alterações da nova Política de Privacidade.")
                    
                    Text("Informaremos Você por e-mail e/ou por aviso destacado em nosso serviço, antes que a alteração entre em vigor, e atualizaremos a data de \"Última atualização\" no topo desta Política de Privacidade.")
                    
                    Text("Recomendamos que Você revise esta Política de Privacidade periodicamente para verificar quaisquer alterações. As alterações a esta Política de Privacidade entram em vigor quando publicadas nesta página.")
                    
                    sectionTitle("14. Fale Conosco")
                    
                    Text("Se Você tiver alguma dúvida sobre esta Política de Privacidade, Você pode entrar em contato conosco:")
                    
                    ListCardComponent(textList: "**Por e-mail:** joao.cssouza1@senacsp.edu.br")
                }
                .font(.footnote)
            }
            .padding()
            .scrollIndicators(.hidden)
        }
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .padding(.top, 8)
    }
    
    private func subsectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.subheadline.bold())
    }
    
    private func subsubsectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.footnote.bold())
    }
    
    let definitions = """
    • **Conta** significa uma conta exclusiva criada para você acessar o Aplicativo.
    • **Aplicativo** refere-se ao Locavio, o programa de software fornecido pela Empresa.
    • **Empresa/Controladora** refere-se ao Locavio, responsável pelas decisões sobre o tratamento dos dados pessoais.
    • **Operador** significa a pessoa (física ou jurídica) que realiza o tratamento de dados pessoais em nome da Controladora — no caso do Locavio, a Apple Inc., por meio dos serviços iCloud e CloudKit.
    • **Titular** significa a pessoa natural a quem se referem os dados pessoais tratados — seja você (usuário/proprietário) ou um inquilino cujos dados sejam inseridos por um proprietário no Aplicativo.
    • **Dados Pessoais** são quaisquer informações relacionadas a uma pessoa natural identificada \nou identificável.
    • **Tratamento** é toda operação realizada com dados pessoais (coleta, uso, armazenamento, compartilhamento, eliminação, etc.).
    • **País**: Brasil.
    • **Dispositivo** significa qualquer iPhone que possa baixar o Aplicativo na AppStore.
    • **Serviço** refere-se ao Aplicativo.
    • **Dados de Uso** referem-se a dados coletados automaticamente, gerados pelo uso do Serviço ou por sua infraestrutura.
    • **Usuário** significa qualquer indivíduo que acesse ou utilize o Serviço.
    • **Você** significa o indivíduo (proprietário) que acessa ou utiliza o Serviço.
    """
    
    let personalData = """
    • Nome e sobrenome
    • E-mail
    • Endereço, Estado, Província, CEP, Cidade
    • Dados dos imóveis cadastrados (endereço, características, fotos)
    • Dados de contratos de locação e valores de aluguel
    • Solicitações de manutenção e histórico de comunicação sobre os imóveis
    • Dados de calendário/agenda relacionados aos imóveis
    • Documentos e fotos que você anexar ao Aplicativo (ex.: contratos, comprovantes)
    """
    
    let dataUsage = """
    • **Para fornecer e manter o nosso Serviço**, incluindo o monitoramento do uso do nosso Serviço.
    • **Para gerenciar sua Conta:** para gerenciar seu registro como usuário do Serviço. Os Dados Pessoais que você fornece podem lhe dar acesso a diferentes funcionalidades do Serviço disponíveis para você como Usuário registrado.
    • **Para entrar em contato com Você:** para contatá-lo por e-mail ou outras formas equivalentes de comunicação eletrônica, como notificações push de aplicativos móveis, referentes a atualizações ou comunicações informativas relacionadas às funcionalidades, produtos ou serviços contratados, incluindo atualizações de segurança, quando necessário ou razoável para sua implementação.
    • **Para gerenciar suas solicitações:** para atender e gerenciar suas solicitações para nós.
    • **Para outras finalidades:** podemos utilizar suas informações para outras finalidades, como análise de dados, identificação de tendências de uso, determinação da eficácia de nossas campanhas promocionais, e avaliação e aprimoramento do nosso Serviço, produtos, serviços, marketing e da \nsua experiência.
    """
    
    let dataSharing = """
    • **Com o Seu consentimento:** podemos divulgar seus Dados Pessoais para qualquer outra finalidade com o seu consentimento.
    • **Com Operadores/Prestadores de Serviços:** com a Apple (iCloud/CloudKit), para armazenamento e funcionamento do Aplicativo;
    • **Com autoridades:** quando exigido por lei ou por ordem de autoridade pública competente;
    """
    
    let thirdPartyData = """
    • Você é responsável por garantir que possui base legal e legitimidade para inserir esses dados no Aplicativo (em regra, a execução do contrato de locação);
    • Você é responsável por informar o inquilino sobre esse tratamento, conforme exigido pela LGPD;
    • A Empresa trata esses dados exclusivamente para viabilizar as funcionalidades do Aplicativo (gestão do contrato, comunicação, histórico de pagamentos), na qualidade de controladora dos sistemas, mas sem relação direta de conta com o inquilino.
    """
    
    #warning("Lembrar de testar o link quando a navegação estiver funcionando!")
    
    let storage = """
    • A Apple processa e armazena os dados exclusivamente conforme nossas instruções e para viabilizar o funcionamento do Aplicativo;
    • Os servidores utilizados podem estar localizados fora do Brasil, o que pode envolver transferência internacional de dados;
    • A Apple aplica suas próprias medidas de segurança e criptografia sobre os dados armazenados via CloudKit; mais informações estão disponíveis na [Política de Privacidade da Apple](https://www.apple.com/legal/privacy/);
    • Não temos acesso direto aos servidores da Apple além do que a API do CloudKit disponibiliza para o funcionamento do Aplicativo.
    """
    
    let dataSubjectRights = """
    • Confirmação da existência de tratamento de seus dados;
    • Acesso aos seus dados;
    • Correção de dados incompletos, inexatos \nou desatualizados;
    • Anonimização, bloqueio ou eliminação de dados desnecessários ou excessivos;
    • Eliminação dos dados tratados com base no seu consentimento;
    """
    
    let legalRequirements = """
    • Cumprir uma obrigação legal
    • Proteger e defender os direitos ou a propriedade da Empresa
    • Prevenir ou investigar possível conduta indevida relacionada ao serviço
    • Proteger a segurança pessoal dos usuários do serviço ou do público
    • Proteger contra responsabilidade legal
    """
}

#Preview {
    PrivacyPolicyView()
}
