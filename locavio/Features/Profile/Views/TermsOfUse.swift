//
//  TermsOfUse.swift
//  locavio
//
//  Created by João Cláudio dos Santos Souza on 30/09/26.
//

import SwiftUI

struct TermsOfUseView: View {
    var body: some View {
        ZStack {
            
            Color.appBg
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Estes termos e condições aplicam-se ao aplicativo Locavio para dispositivos móveis, juntamente com quaisquer serviços relacionados operados pelo Locavio (coletivamente, o \"Aplicativo\"). O Locavio é aqui referido como o \"Provedor de Serviços\".")
                    
                    Text("Ao baixar ou usar o Aplicativo, você concorda com estes Termos e Condições. Você deve lê-los cuidadosamente antes de usar o Aplicativo.")
                    
                    sectionTitle("1. Licença de uso do Aplicativo")
                    
                    Text("Sujeito ao seu cumprimento destes Termos, o Provedor de Serviços concede a você uma licença limitada, não exclusiva, intransferível e revogável para instalar e usar o Aplicativo em um dispositivo móvel para fins pessoais ou comerciais internos. Você não pode reproduzir, distribuir, modificar, criar trabalhos derivados, fazer engenharia reversa, descompilar ou desmontar o Aplicativo, exceto e apenas na medida em que tal atividade seja expressamente permitida pela lei aplicável.")
                    
                    Text("Esta licença restringe-se ao uso do Aplicativo exclusivamente em dispositivos com sistemas operacionais iOS (produtos da marca Apple) que o Utilizador possua ou controle legitimamente, e em estrita observância com as Regras de Uso delineadas nos Termos de Serviço da Apple Media Services.")
                    
                    sectionTitle("2. Propriedade Intelectual")
                    
                    Text("O Provedor de Serviços retém todos os direitos de propriedade intelectual sobre o Aplicativo, incluindo seu código, design, marcas registradas, marcas de serviço, nomes comerciais, logotipos e identidade visual (a \"PI\"). Nada nestes Termos concede a você qualquer licença ou direito de usar as marcas registradas, logotipos ou identidade visual do Provedor de Serviços para qualquer finalidade. Você concorda em não remover, alterar ou ocultar quaisquer avisos de direitos autorais, marcas registradas ou outros avisos de propriedade exibidos no ou dentro do Aplicativo.")
                    
                    sectionTitle("3. Rescisão")
                    
                    Text("O Provedor de Serviços pode suspender seu acesso ao Aplicativo ou aos serviços se você violar materialmente estes Termos. O Provedor de Serviços fornecerá um aviso por escrito sobre a violação.")
                    
                    Text("O Provedor de Serviços pode suspender ou rescindir seu acesso imediatamente sem aviso prévio se você violar a lei aplicável, infringir direitos de propriedade intelectual ou se envolver em atividades que possam causar danos a outros usuários ou ao Provedor de Serviços.")
                    
                    Text("Após a rescisão, seu direito de usar o Aplicativo terminará e você deverá excluir todas as cópias de seus dispositivos.")
                    
                    Text("Ao acessar e usar este Aplicativo, você declara que tem permissão legal para usá-lo em sua jurisdição. Você deve ter pelo menos 18 anos de idade (a idade de consentimento digital em sua jurisdição) para usar \no Aplicativo.")
                    
                    Text("A cópia não autorizada, modificação do Aplicativo, qualquer parte do Aplicativo ou das marcas registradas do Provedor de Serviços é estritamente proibida. Quaisquer tentativas de extrair o código-fonte do Aplicativo, traduzir o Aplicativo para outros idiomas ou criar versões derivadas não são permitidas. Todas as marcas registradas, direitos autorais, direitos de banco de dados e outros direitos de propriedade intelectual relacionados ao Aplicativo permanecem como propriedade do Provedor de Serviços.")
                    
                    Text("O Utilizador detém a autonomia plena para solicitar a exclusão definitiva da sua conta a qualquer momento, funcionalidade que se encontra disponível nativamente nas configurações do Aplicativo. A confirmação da exclusão de conta engatilhará, por intermédio da API da Apple, a revogação automática dos tokens de acesso e de atualização associados à autenticação do Utilizador. Simultaneamente, será iniciado o expurgo definitivo de todos os dados do banco de dados relacional e arquivos em nuvem (como perfis de propriedades, cadastros de inquilinos, relatórios de despesas, contratos anexados e fotografias de vistorias), excetuando-se apenas os registros de acesso que devem ser mantidos, sob sigilo, pelo prazo obrigatório de seis meses para cumprimento do Marco Civil da Internet (Lei nº 12.965/2014).")
                    
                    sectionTitle("4. Conteúdo Gerado pelo Usuário e Uso Aceitável")
                    
                    Text("Se este Aplicativo permitir que os usuários publiquem, compartilhem ou façam upload de conteúdo, você concorda em não publicar conteúdo que:")
                    
                    ListCardComponent(textList: prohibitedContent)
                    
                    Text("O Provedor de Serviços reserva-se o direito de:")
                    
                    ListCardComponent(textList: providerRights)
                    
                    Text("Se você acredita que um conteúdo viola estes Termos, infringe seus direitos ou é ilegal, você pode denunciá-lo ao Provedor de Serviços em [jusampa2@gmail.com](mailto:jusampa2@gmail.com). A denúncia deve incluir informações suficientes para que o Provedor de Serviços identifique o conteúdo, avalie a reclamação e entre em contato com você caso seja necessário acompanhamento.")
                    
                    Text("O Provedor de Serviços pode revisar o conteúdo denunciado, solicitar informações adicionais quando necessário, remover ou restringir o acesso ao conteúdo e tomar medidas contra a conta responsável quando apropriado. Os usuários afetados por decisões de moderação podem entrar em contato com o Provedor de Serviços em [jusampa2@gmail.com](mailto:jusampa2@gmail.com) para solicitar uma revisão adicional. O Provedor de Serviços responderá às apelações dentro de um período razoável e fornecerá os motivos para qualquer decisão de moderação mantida, sujeito à lei aplicável.")
                    
                    Text("Ao enviar Conteúdo Gerado pelo Usuário, você concede ao Provedor de Serviços uma licença mundial, isenta de royalties e não exclusiva para usar, reproduzir, distribuir, preparar trabalhos derivados, exibir e executar o conteúdo em conexão com o Aplicativo e os negócios do Provedor de Serviços. Esta licença não concede ao Provedor de Serviços o direito de vender ou sublicenciar seu conteúdo a terceiros de forma independente do Aplicativo. Você declara e garante que possui ou controla todos os direitos sobre o conteúdo que publica e que o uso do conteúdo não viola estes Termos ou a lei aplicável.")
                    
                    Text("Seu conteúdo pode incluir dados pessoais. O processamento de dados pessoais relacionados ao Conteúdo Gerado pelo Usuário é regido pela Política de Privacidade. Não publique dados pessoais de terceiros sem o consentimento deles.")
                    
                    Text("O Aplicativo armazena e processa dados pessoais que você forneceu ao Provedor de Serviços para prestar o Serviço. É sua responsabilidade manter a segurança de seu dispositivo móvel e o acesso ao Aplicativo.")
                    
                    Text("O Provedor de Serviços aconselha expressamente que você não faça jailbreak ou root em seu dispositivo móvel, o que envolve a remoção de restrições e limitações de software impostas pelo sistema operacional oficial de seu dispositivo móvel. Tais ações podem expor seu dispositivo móvel a malwares, vírus e programas maliciosos, comprometer os recursos de segurança de seu dispositivo e podem resultar no funcionamento incorreto ou na inoperabilidade total do Aplicativo.")
                    
                    Text("Fazer o jailbreak ou manipular o sistema operacional base compromete a criptografia local do dispositivo, podendo resultar na corrupção irremediável de chaves de autenticação e na exposição indevida dos dados contratuais armazenados a agentes maliciosos, o que isenta o Locavio de qualquer responsabilidade por incidentes de segurança cibernética.")
                    
                    Text("Esteja ciente de que o Provedor de Serviços não assume responsabilidade por certos aspectos. Algumas funções do Aplicativo exigem uma conexão ativa com a internet, que pode ser via Wi-Fi ou fornecida por sua operadora de rede móvel. O Provedor de Serviços não pode ser responsabilizado se o Aplicativo não funcionar em sua capacidade total devido à falta de acesso a uma rede Wi-Fi ou se o seu pacote de dados houver esgotado.")
                    
                    Text("Se você estiver usando o aplicativo fora de uma área com Wi-Fi, lembre-se de que os termos do contrato de sua operadora de rede móvel ainda se aplicam. Consequentemente, você pode ser cobrado por sua operadora móvel pelo uso de dados durante a conexão com o aplicativo, ou por outras cobranças de terceiros. Ao usar o aplicativo, você aceita a responsabilidade por tais cobranças, incluindo tarifas de roaming de dados, caso use o aplicativo fora de seu território de origem (ou seja, região ou país) sem desativar o roaming de dados. Se você não for o pagador da fatura do dispositivo no qual está usando o aplicativo, eles presumem que você obteve permissão \ndo pagador.")
                    
                    Text("Da mesma forma, o Provedor de Serviços não pode assumir responsabilidade pelo seu uso do aplicativo em todas as situações. Por exemplo, é sua responsabilidade garantir que seu dispositivo permaneça carregado. Se a bateria do seu dispositivo acabar e você não puder acessar o Serviço, o Provedor de Serviços não poderá \nser responsabilizado.")
                    
                    Text("Nada nestes Termos limitará quaisquer direitos que você tenha sob as leis de proteção ao consumidor aplicáveis que não possam ser legalmente excluídos.")
                    
                    Text("O preenchimento automático de endereços de propriedades imobiliárias é potencializado pela integração técnica com a API pública ViaCEP. O Aplicativo transmite exclusivamente o código numérico do CEP a esta API externa para resguardar a privacidade, fundindo a informação genérica com os dados sensíveis do imóvel apenas posteriormente e de forma encriptada. O Utilizador isenta o Locavio de responsabilidade por preenchimentos incorretos ou interrupções no cadastro de imóveis decorrentes de instabilidades no serviço ViaCEP ou na conectividade mantida por terceiros.")
                    
                    sectionTitle("5. Limitação de Responsabilidade")
                    
                    Text("Na extensão máxima permitida por lei, o Provedor de Serviços não será responsável por quaisquer danos indiretos, incidentais, especiais, consequenciais ou punitivos, incluindo, mas não se limitando a, lucros cessantes, perda de dados ou interrupção de negócios, mesmo que avisado da possibilidade de tais danos.")
                    
                    Text("Além disso, o Provedor de Serviços não contém nenhuma responsabilidade por:")
                    
                    ListCardComponent(textList: liabilityExclusions)
                    
                    Text("O Provedor de Serviços não aceita qualquer responsabilidade por qualquer perda, direta ou indireta, que você venha a sofrer como resultado de confiar inteiramente em informações de terceiros fornecidas por meio deste Aplicativo, ou por imprecisões no conteúdo fornecido por terceiros.")
                    
                    Text("O Locavio assume a responsabilidade total pelo fornecimento de serviços de manutenção e suporte técnico referentes ao Aplicativo. O Utilizador e o Locavio reconhecem que a Apple não tem, sob nenhuma circunstância, qualquer obrigação de fornecer serviços de manutenção e suporte técnico relacionados ao Aplicativo, nem qualquer outra obrigação de garantia. Na extensão máxima permitida pela lei aplicável, recai inteiramente sobre o Locavio a responsabilidade por reivindicações, falhas de sistema e proteção ao consumidor. Em caso de alegações de terceiros de que o aplicativo infringe direitos de propriedade intelectual, a investigação, defesa e liquidação de tais reivindicações são de exclusiva responsabilidade do Locavio, e não da Apple.")
                    
                    sectionTitle("6. Indenização")
                    
                    Text("Na extensão máxima permitida por lei, você concorda em indenizar e isentar o Provedor de Serviços, suas afiliadas, diretores, conselheiros, funcionários e agentes de e contra quaisquer reclamações, responsabilidades, danos, perdas e despesas, incluindo honorários advocatícios razoáveis, decorrentes de ou diretamente relacionados à sua violação destes Termos ou ao seu uso indevido intencional do Aplicativo, incluindo Conteúdo Gerado pelo Usuário que você enviar em violação a estes Termos.")
                    
                    Text("Esta indenização não se aplica a reclamações decorrentes da própria negligência do Provedor de Serviços, violação destes Termos ou violação da lei aplicável. Em jurisdições onde a indenização por parte do consumidor é restrita por lei, esta cláusula será limitada à extensão \nmáxima permitida.")
                    
                    sectionTitle("7. Atualizações do Aplicativo")
                    
                    Text("O Provedor de Serviços pode desejar atualizar o aplicativo em algum momento. O aplicativo está atualmente disponível de acordo com os requisitos do sistema operacional (e de quaisquer sistemas adicionais para os quais eles decidam estender a disponibilidade do aplicativo), que podem mudar, e você precisará baixar as atualizações se quiser continuar usando o aplicativo. O Provedor de Serviços não garante que sempre atualizará o aplicativo para que ele continue relevante para você e/ou compatível com a versão específica do sistema operacional instalada em seu dispositivo. Você deve aceitar as atualizações quando forem oferecidas; caso decida não as aceitar, o Provedor de Serviços poderá deixar de oferecer suporte a versões anteriores e o Aplicativo poderá não funcionar adequadamente. O Provedor de Serviços também pode desejar parar de fornecer o aplicativo e pode encerrar o seu uso a qualquer momento sem fornecer aviso de rescisão a você. A menos que informem o contrário, mediante qualquer rescisão, (a) os direitos e licenças concedidos a você nestes termos terminarão; (b) você deve parar de usar o aplicativo e (se necessário) excluí-lo de seu dispositivo.")
                    
                    sectionTitle("8. Lei Aplicável e Jurisdição")
                    
                    Text("Estes Termos e Condições são submetidos exclusivamente à legislação da República Federativa do Brasil, em especial à Lei Geral de Proteção de Dados Pessoais (LGPD - Lei nº 13.709/2018) e ao Marco Civil da Internet \n(Lei nº 12.965/2014).")
                    
                    Text("Qualquer litígio decorrente de ou relacionado a estes Termos será submetido aos tribunais que tenham jurisdição sob a lei aplicável, ficando desde logo eleito o foro do domicílio do Utilizador, sob a égide dos princípios protetivos do Código de Defesa do Consumidor, na medida do aplicável.")
                    
                    sectionTitle("9. Conformidade com a App Store e Posição da Apple")
                    
                    Text("O Utilizador e o Locavio reconhecem e acordam expressamente que este contrato é firmado única e exclusivamente entre as referidas partes, não configurando qualquer vínculo contratual com a Apple Inc. ou as suas subsidiárias (\"Apple\"). O Locavio, e não a Apple, é o único responsável pelo Aplicativo e pelo conteúdo nele inserido. O Utilizador e o Locavio reconhecem que a Apple e as suas subsidiárias são terceiros beneficiários destes Termos e que, mediante a aceitação do Utilizador, a Apple terá o direito legal de executar as disposições deste contrato diretamente contra o Utilizador, na qualidade de \nterceiro beneficiário.")
                    
                    sectionTitle("10. Regimes de Tratamento de Dados e Privacidade (LGPD)")
                    
                    Text("O processamento de dados dentro do Aplicativo cria papéis distintos de responsabilidade legal. O Locavio atua como Controlador de Dados exclusivamente no que se refere aos dados de cadastro do próprio proprietário do imóvel para a criação e manutenção da conta (como endereço de e-mail, nome e dados de assinatura in-app).")
                    
                    Text("No que tange aos dados dos inquilinos, contratos de locação digitalizados, recibos financeiros e fotos de vistorias inseridas no aplicativo, o Locavio atua estritamente como Operador tecnológico da infraestrutura. O Utilizador (proprietário do imóvel) assume integralmente a figura de Controlador destes dados perante os seus inquilinos, sendo o único responsável por possuir base legal válida (como a execução de contrato de locação) para cadastrar e processar essas informações sensíveis \nde terceiros.")
                    
                    Text("O Utilizador compromete-se a indenizar o Locavio contra quaisquer sanções, multas, ações judiciais ou autuações por parte da Autoridade Nacional de Proteção de Dados (ANPD) que sejam decorrentes do tratamento ilícito, abusivo ou desprovido de base legal dos dados de inquilinos e terceiros inseridos no Aplicativo pelo Utilizador.")
                    
                    sectionTitle("11. Independência das Disposições (Separabilidade)")
                    
                    Text("Se qualquer disposição destes Termos e Condições for considerada inválida, ilegal ou inexequível por um tribunal de jurisdição competente, tal disposição será modificada na medida mínima necessária para torná-la válida e exequível, e as demais disposições destes Termos permanecerão em pleno vigor e efeito.")
                    
                    sectionTitle("12. Acordo Integral")
                    
                    Text("Estes Termos e Condições, juntamente com a Política de Privacidade, constituem o acordo integral entre você e o Provedor de Serviços em relação ao seu uso do Aplicativo, substituindo quaisquer acordos ou \nentendimentos anteriores.")
                    
                    sectionTitle("13. Alterações nestes Termos e Condições")
                    
                    Text("O Provedor de Serviços pode atualizar seus Termos e Condições periodicamente. Portanto, é aconselhável que você analise esta página regularmente para verificar quaisquer alterações. O Provedor de Serviços o notificará sobre quaisquer alterações publicando os novos Termos e Condições nesta página.")
                    
                    Text("Versões anteriores destes Termos e Condições serão mantidas e disponibilizadas mediante solicitação, entrando em contato com o Provedor de Serviços \nem [jusampa2@gmail.com](mailto:jusampa2@gmail.com).")
                    
                    Text("Estes termos e condições entram em vigor a partir \nde 25-09-2026.")
                    
                    sectionTitle("14. Fale Conosco")
                    
                    Text("Se você tiver alguma dúvida ou sugestão sobre os Termos e Condições, não hesite em entrar em contato com o Provedor de Serviços em [jusampa2@gmail.com](mailto:jusampa2@gmail.com).")
                }
                .font(.footnote)
            }
            .padding()
            .scrollIndicators(.hidden)
        }
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Termos de Uso")
        .ignoresSafeArea(edges: .bottom)
    }
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .padding(.top, 8)
    }
    
    let prohibitedContent = """
    • Seja ilegal ou viole direitos de propriedade intelectual de terceiros (direitos autorais, marcas registradas, patentes)
    • Seja abusivo, ameaçador, assediador, difamatório ou discurso de ódio
    • Contenha discriminação ou incitação à violência ou a atividades ilegais
    • Seja spam, phishing ou contenha malware
    • Viole a privacidade ou os direitos de dados pessoais de terceiros
    • Seja enganoso, falso ou fraudulento
    • Contenha violência explícita ou conteúdo sexual
    """
    
    let providerRights = """
    • Remover ou desativar o acesso a conteúdo que viole estas diretrizes
    • Suspender ou encerrar as contas de usuários que violarem repetidamente estas diretrizes
    • Cooperar com as autoridades policiais caso conteúdo ilegal seja denunciado
    • Moderar, filtrar ou ocultar conteúdo que viole estes Termos, a lei aplicável ou as diretrizes estabelecidas acima
    """
    
    let liabilityExclusions = """
    • Morte ou lesão corporal causada por negligência
    • Fraude ou declaração falsa fraudulenta
    • Qualquer outra responsabilidade que não possa ser excluída ou limitada de acordo com a lei aplicável
    """
}

#Preview {
    TermsOfUseView()
}
