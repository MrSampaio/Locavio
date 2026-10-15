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
                    Text("Estes termos e condições aplicam-se ao aplicativo Locavio para dispositivos móveis, juntamente com quaisquer serviços relacionados operados pelo Locavio. O Locavio é aqui referido como o \"Provedor de Serviços\".")
                    
                    Text("O Locavio é um aplicativo destinado à gestão imobiliária, que contempla a criação e manutenção de perfis de propriedades com preenchimento automático de endereços, o cadastro de inquilinos, o acompanhamento de relatórios de despesas, o armazenamento de recibos financeiros, além da anexação de contratos de locação digitalizados e fotografias de vistorias.")
                    
                    Text("Ao baixar ou usar o Aplicativo, você concorda com estes Termos e Condições. Você deve lê-los cuidadosamente antes de usar o Aplicativo.")
                    
                    sectionTitle("1. Licença de uso do Aplicativo")
                    
                    Text("Sujeito ao seu cumprimento destes Termos, o Provedor de Serviços concede a você uma licença limitada, não exclusiva, intransferível e revogável para instalar e usar o Aplicativo em um dispositivo móvel para fins pessoais ou comerciais internos. Você não pode reproduzir, distribuir, modificar, criar trabalhos derivados, fazer engenharia reversa, descompilar ou desmontar o Aplicativo, exceto e apenas na medida em que tal atividade seja expressamente permitida pela lei aplicável.")
                    
                    Text("Esta licença restringe-se ao uso do Aplicativo exclusivamente em dispositivos com sistemas operacionais iOS (produtos da marca Apple) que o Usuário possua ou controle legitimamente, e em estrita observância com as Regras de Uso delineadas nos Termos de Serviço da Apple Media Services.")
                    
                    sectionTitle("2. Propriedade Intelectual")
                    
                    Text("O Provedor de Serviços retém todos os direitos de propriedade intelectual sobre o Aplicativo, incluindo seu código, design, marcas registradas, marcas de serviço, nomes comerciais, logotipos e identidade visual (a \"PI\"). Nada nestes Termos concede a você qualquer licença ou direito de usar as marcas registradas, logotipos ou identidade visual do Provedor de Serviços para qualquer finalidade. Você concorda em não remover, alterar ou ocultar quaisquer avisos de direitos autorais, marcas registradas ou outros avisos de propriedade exibidos no ou dentro do Aplicativo.")
                    
                    sectionTitle("3. Rescisão")
                    
                    Text("O Provedor de Serviços pode suspender seu acesso ao Aplicativo ou aos serviços se você violar estes Termos. O Provedor de Serviços fornecerá um aviso por escrito sobre a violação por email.")
                    
                    Text("O Provedor de Serviços pode suspender ou rescindir seu acesso imediatamente sem aviso prévio se você violar a lei aplicável, infringir direitos de propriedade intelectual ou se envolver em atividades que possam causar danos a outros usuários ou ao Provedor de Serviços.")
                    
                    Text("Após a rescisão, seu direito de usar o Aplicativo terminará e você deverá excluir todas as cópias de seus dispositivos.")
                    
                    Text("Ao acessar e usar este Aplicativo, você declara que tem permissão legal para usá-lo em sua jurisdição. Você deve ter pelo menos 18 anos de idade (a idade de consentimento digital em sua jurisdição) para usar o Aplicativo.")
                    
                    Text("A cópia não autorizada, modificação do Aplicativo, qualquer parte do Aplicativo ou das marcas registradas do Provedor de Serviços é estritamente proibida. Quaisquer tentativas de extrair o código-fonte do Aplicativo, traduzir o Aplicativo para outros idiomas ou criar versões derivadas não são permitidas. Todas as marcas registradas, direitos autorais, direitos de banco de dados e outros direitos de propriedade intelectual relacionados ao Aplicativo permanecem como propriedade do Provedor de Serviços.")
                    
                    Text("O Usuário detém a autonomia plena para solicitar a exclusão definitiva da sua conta a qualquer momento, funcionalidade que se encontra disponível nativamente nas configurações do Aplicativo.")
                    
                    Text("A confirmação da exclusão da conta, por meio da API da Apple, irá revogar o acesso e atualização do usuário no App. Ao mesmo tempo, será feita a limpeza completa de todos os dados do usuário do banco de dado e seus respectivos arquivos em nuvem (como perfis de propriedades, cadastros de inquilinos, relatórios de despesas, contratos anexados e fotografias de vistorias), salvo apenas os registros de acesso (Endereço IP utilizado em cada acesso, Data e Hora exatas do acesso e hash do identificador do Usuário) que devem ser mantidos, sob sigilo, pelo prazo obrigatório de seis meses para cumprimento do Marco Civil da Internet (Lei nº 12.965/2014).")
                    
                    sectionTitle("4. Inserção de Dados, Documentos e Uso Aceitável")
                    
                    Text("O Aplicativo permite que você insira dados, fotografias e documentos (como contratos de locação, vistorias e comprovantes financeiros) exclusivamente para fins de gestão privada de seus imóveis. Ao utilizar essas funcionalidades, você concorda em não inserir ou armazenar no Aplicativo arquivos ou informações que:")
                    
                    ListCardComponent(textList: prohibitedContent)
                    
                    Text("Como o Locavio é uma ferramenta de uso estritamente privado, o Provedor de Serviços não realiza moderação ativa, filtragem ou análise do conteúdo que você armazena. No entanto, o Provedor de Serviços reserva-se o direito de:")
                    
                    ListCardComponent(textList: providerRights)
                    
                    Text("Ao inserir dados e documentos no Aplicativo, você mantém todos os direitos de propriedade sobre eles. Você concede ao Provedor de Serviços apenas a licença técnica estritamente necessária para processar, sincronizar e exibir essas informações exclusivamente para o seu próprio acesso dentro do Aplicativo, não havendo qualquer uso, venda ou distribuição do seu conteúdo a terceiros por parte do Provedor de Serviços.")
                    
                    Text("O processamento de dados pessoais relacionados às informações que você insere (especialmente dados de inquilinos) é regido pela nossa Política de Privacidade. O Aplicativo atua apenas como infraestrutura tecnológica para o armazenamento destes dados.")
                    
                    Text("É de sua exclusiva responsabilidade manter a segurança de seu dispositivo móvel e o acesso ao Aplicativo. O Provedor de Serviços aconselha expressamente que você não faça jailbreak ou root em seu dispositivo móvel. Tais ações removem as restrições de software impostas pelo sistema operacional, podendo comprometer a criptografia local do dispositivo. Isso pode resultar na corrupção irremediável de chaves de autenticação e na exposição indevida dos dados contratuais e financeiros armazenados a agentes maliciosos, isentando o Locavio de qualquer responsabilidade por incidentes de segurança cibernética decorrentes destas práticas.")
                    
                    Text("Algumas funções do Aplicativo exigem uma conexão ativa com a internet. O Provedor de Serviços não pode ser responsabilizado se o Aplicativo não funcionar em sua capacidade total devido à falta de acesso à rede, instabilidades de conexão ou esgotamento do seu pacote de dados móveis. O Provedor de Serviços também não assume responsabilidade caso você fique impossibilitado de acessar o Serviço devido à falta de bateria no seu dispositivo.")
                    
                    Text("O preenchimento automático de endereços de propriedades imobiliárias é potencializado pela integração técnica com a API pública ViaCEP. O Aplicativo transmite exclusivamente o código numérico do CEP a esta API externa para resguardar a privacidade, fundindo a informação genérica com os dados sensíveis do imóvel apenas posteriormente e de forma encriptada. O Usuário isenta o Locavio de responsabilidade por preenchimentos incorretos ou interrupções no cadastro de imóveis decorrentes de instabilidades no serviço ViaCEP ou na conectividade mantida por terceiros.")
                    
                    Text("Nada nestes Termos limitará quaisquer direitos que você tenha sob as leis de proteção ao consumidor aplicáveis que não possam ser legalmente excluídos.")
                    
                    sectionTitle("5. Limitação de Responsabilidade")
                    
                    Text("Na extensão máxima permitida por lei, o Provedor de Serviços não será responsável por quaisquer danos indiretos, incidentais, especiais, consequenciais ou punitivos, incluindo, mas não se limitando a, lucros cessantes, perda de dados ou interrupção de negócios, mesmo que avisado da possibilidade de tais danos.")
                    
                    Text("Além disso, o Provedor de Serviços não contém nenhuma responsabilidade por:")
                    
                    ListCardComponent(textList: liabilityExclusions)
                    
                    Text("O Provedor de Serviços não aceita qualquer responsabilidade por qualquer perda, direta ou indireta, que você venha a sofrer como resultado de confiar inteiramente em informações de terceiros fornecidas por meio deste Aplicativo, ou por imprecisões no conteúdo fornecido por terceiros.")
                    
                    Text("O Locavio assume a responsabilidade total pelo fornecimento de serviços de manutenção e suporte técnico referentes ao Aplicativo. O Usuário e o Locavio reconhecem que a Apple não tem, sob nenhuma circunstância, qualquer obrigação de fornecer serviços de manutenção e suporte técnico relacionados ao Aplicativo, nem qualquer outra obrigação de garantia. Na extensão máxima permitida pela lei aplicável, recai inteiramente sobre o Locavio a responsabilidade por reivindicações, falhas de sistema e proteção ao consumidor. Em caso de alegações de terceiros de que o aplicativo infringe direitos de propriedade intelectual, a investigação, defesa e liquidação de tais reivindicações são de exclusiva responsabilidade do Locavio, e não da Apple.")
                    
                    sectionTitle("6. Indenização")
                    
                    Text("Na extensão máxima permitida por lei, você concorda em indenizar e isentar o Provedor de Serviços, suas afiliadas, diretores, conselheiros, funcionários e agentes de e contra quaisquer reclamações, responsabilidades, danos, perdas e despesas, incluindo honorários advocatícios razoáveis, decorrentes de ou diretamente relacionados à sua violação destes Termos ou ao seu uso indevido intencional do Aplicativo, incluindo Conteúdo Gerado pelo Usuário que você enviar em violação a estes Termos.")
                    
                    Text("Esta indenização não se aplica a reclamações decorrentes da própria negligência do Provedor de Serviços, violação destes Termos ou violação da lei aplicável. Em jurisdições onde a indenização por parte do consumidor é restrita por lei, esta cláusula será limitada à extensão máxima permitida.")
                    
                    sectionTitle("7. Atualizações do Aplicativo")
                    
                    Text("O Provedor de Serviços pode desejar atualizar o aplicativo em algum momento. O aplicativo está atualmente disponível de acordo com os requisitos do sistema operacional (e de quaisquer sistemas adicionais para os quais eles decidam estender a disponibilidade do aplicativo), que podem mudar, e você precisará baixar as atualizações se quiser continuar usando o aplicativo. O Provedor de Serviços não garante que sempre atualizará o aplicativo para que ele continue relevante para você e/ou compatível com a versão específica do sistema operacional instalada em seu dispositivo. Você deve aceitar as atualizações quando forem oferecidas; caso decida não as aceitar, o Provedor de Serviços poderá deixar de oferecer suporte a versões anteriores e o Aplicativo poderá não funcionar adequadamente. O Provedor de Serviços também pode desejar parar de fornecer o aplicativo e pode encerrar o seu uso a qualquer momento sem fornecer aviso de rescisão a você. A menos que informem o contrário, mediante qualquer rescisão, (a) os direitos e licenças concedidos a você nestes termos terminarão; (b) você deve parar de usar o aplicativo e (se necessário) excluí-lo de seu dispositivo.")
                    
                    sectionTitle("8. Lei Aplicável e Jurisdição")
                    
                    Text("Estes Termos e Condições são submetidos exclusivamente à legislação da República Federativa do Brasil, em especial à Lei Geral de Proteção de Dados Pessoais (LGPD - Lei nº 13.709/2018) e ao Marco Civil da Internet (Lei nº 12.965/2014).")
                    
                    Text("Qualquer litígio decorrente de ou relacionado a estes Termos será submetido aos tribunais que tenham jurisdição sob a lei aplicável, ficando desde logo eleito o foro do domicílio do Usuário, sob a égide dos princípios protetivos do Código de Defesa do Consumidor, na medida do aplicável.")
                    
                    sectionTitle("9. Conformidade com a App Store e Posição da Apple")
                    
                    Text("O Usuário e o Locavio reconhecem e acordam expressamente que este contrato é firmado única e exclusivamente entre as referidas partes, não configurando qualquer vínculo contratual com a Apple Inc. ou as suas subsidiárias (\"Apple\"). O Locavio, e não a Apple, é o único responsável pelo Aplicativo e pelo conteúdo nele inserido. O Usuário e o Locavio reconhecem que a Apple e as suas subsidiárias são terceiros beneficiários destes Termos e que, mediante a aceitação do Usuário, a Apple terá o direito legal de executar as disposições deste contrato diretamente contra o Usuário, na qualidade de terceiro beneficiário.")
                    
                    sectionTitle("10. Regimes de Tratamento de Dados e Privacidade (LGPD)")
                    
                    Text("O processamento de dados dentro do Aplicativo cria papéis distintos de responsabilidade legal. O Locavio atua como Controlador de Dados exclusivamente no que se refere aos dados de cadastro do próprio proprietário do imóvel para a criação e manutenção da conta (como endereço de e-mail, nome e dados de assinatura in-app).")
                    
                    Text("No que tange aos dados dos inquilinos, contratos de locação digitalizados, recibos financeiros e fotos de vistorias inseridas no aplicativo, o Locavio atua estritamente como Operador tecnológico da infraestrutura. O Usuário (proprietário do imóvel) assume integralmente a figura de Controlador destes dados perante os seus inquilinos, sendo o único responsável por possuir base legal válida (como a execução de contrato de locação) para cadastrar e processar essas informações sensíveis de terceiros.")
                    
                    Text("O Usuário compromete-se a indenizar o Locavio contra quaisquer sanções, multas, ações judiciais ou autuações por parte da Autoridade Nacional de Proteção de Dados (ANPD) que sejam decorrentes do tratamento ilícito, abusivo ou desprovido de base legal dos dados de inquilinos e terceiros inseridos no Aplicativo pelo Usuário.")
                    
                    sectionTitle("11. Independência das Disposições (Separabilidade)")
                    
                    Text("Se qualquer disposição destes Termos e Condições for considerada inválida, ilegal ou inexequível por um tribunal de jurisdição competente, tal disposição será modificada na medida mínima necessária para torná-la válida e exequível, e as demais disposições destes Termos permanecerão em pleno vigor e efeito.")
                    
                    sectionTitle("12. Acordo Integral")
                    
                    Text("Estes Termos e Condições, juntamente com a Política de Privacidade, constituem o acordo integral entre você e o Provedor de Serviços em relação ao seu uso do Aplicativo, substituindo quaisquer acordos ou entendimentos anteriores.")
                    
                    sectionTitle("13. Alterações nestes Termos e Condições")
                    
                    Text("O Provedor de Serviços pode atualizar seus Termos e Condições periodicamente. Portanto, é aconselhável que você analise esta página regularmente para verificar quaisquer alterações. O Provedor de Serviços o notificará sobre quaisquer alterações publicando os novos Termos e Condições nesta página.")
                    
                    Text("Versões anteriores destes Termos e Condições serão mantidas e disponibilizadas mediante solicitação, entrando em contato com o Provedor de Serviços em [locaviodev@gmail.com](mailto:locaviodev@gmail.com).")
                    
                    Text("Estes termos e condições entram em vigor a partir de 25-09-2026.")
                    
                    sectionTitle("14. Fale Conosco")
                    
                    Text("Se você tiver alguma dúvida ou sugestão sobre os Termos e Condições, não hesite em entrar em contato com o Provedor de Serviços em [locaviodev@gmail.com](mailto:locaviodev@gmail.com).")
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
    -    Sejam ilegais, fraudulentos, falsificados ou violem direitos de propriedade intelectual de terceiros;
    -    Violem a privacidade ou os direitos de dados pessoais de terceiros (como inserir dados sensíveis de inquilinos sem possuir uma base legal válida para tal, conforme a LGPD);
    -    Contenham vírus, malware ou códigos maliciosos que possam comprometer a segurança do seu dispositivo, do Aplicativo ou da infraestrutura em nuvem.
    """
    
    let providerRights = """
    -    Suspender ou encerrar o acesso de contas que utilizem o Aplicativo de forma comprovadamente ilícita (como para fraudes imobiliárias ou lavagem de dinheiro);
    -    Cooperar com autoridades policiais ou judiciais caso seja legalmente exigido.
    """
    
    let liabilityExclusions = """
    -    Morte ou lesão corporal causada por negligência
    -    Fraude ou declaração falsa fraudulenta
    -    Qualquer outra responsabilidade que não possa ser excluída ou limitada de acordo com a lei aplicável
    """
}

#Preview {
    TermsOfUseView()
}
