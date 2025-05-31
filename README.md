# Projeto Hackatona - Wiki do Aplicativo iOS de Feedback

## 📱 Visão Geral

O Projeto Incentiv8 é um aplicativo iOS abrangente de feedback construído com Swift e UIKit. Ele permite que funcionários deem e recebam feedback, visualizem rankings, participem de atividades, acessem recursos e resgatem benefícios através de um sistema baseado em pontos. O aplicativo se integra com uma API backend em Go para gerenciar dados e interações do usuário.

### Funcionalidades Principais

- **Sistema de Feedback**: Dar e receber feedback estruturado com avaliação por estrelas
- **Sistema de Ranking**: Visualizar rankings de funcionários, locais e eventos
- **Scanner de QR Code**: Escanear códigos QR para interações rápidas
- **Pontos e Recompensas**: Ganhar e gastar pontos na loja integrada
- **Biblioteca de Recursos**: Acessar materiais educacionais e recursos
- **Gerenciamento de Atividades**: Visualizar e participar de eventos da empresa
- **Feedback por Áudio**: Gravar feedback de voz além de texto

---

## 🏗️ Arquitetura

### Padrão de Design

A aplicação segue o padrão de arquitetura **MVC (Model-View-Controller)** com:

- **Protocolo ViewCode**: Componentes de UI customizados construídos programaticamente
- **Padrão Delegate**: Para gerenciar interações do usuário e fluxo de dados
- **Async/Await**: Concorrência moderna do Swift para chamadas de API

### Estrutura do Projeto

```
hackatona-project/
├── AppDelegate.swift
├── SceneDelegate.swift
├── Extensions.swift
├── ViewController/
├── Components/
├── Model/
├── Protocols/
└── Assets.xcassets/
```

---

## 📁 Componentes Principais

### View Controllers

#### 1. TabBarController.swift

- **Propósito**: Hub de navegação principal com 5 abas
- **Funcionalidades**:
  - Tab bar customizada com integração de scanner QR
  - Funcionalidade de câmera com AVFoundation
  - Dismissal da câmera baseado em gestos
  - Itens das abas: Perfil, Feedback, Câmera, Ranking, Loja

#### 2. ProfileVC.swift

- **Propósito**: Perfil do usuário com histórico de feedback
- **Funcionalidades**:
  - Serviço de API customizado para buscar dados do usuário
  - Seções de feedback recebido e enviado
  - Exibição de avaliação por estrelas
  - Rastreamento de pontos e saldo
  - Células de table view customizadas com cantos arredondados

#### 3. FeedbackVC.swift

- **Propósito**: Navegar e pesquisar funcionários, recursos e atividades
- **Funcionalidades**:
  - Controle segmentado para diferentes tipos de conteúdo
  - Secionamento alfabético com funcionalidade de busca
  - Diretório de funcionários com cargos
  - Biblioteca de recursos (livros, artigos, vídeos)
  - Calendário de atividades com avaliações

#### 4. CreateFeedbackVC.swift

- **Propósito**: Criar novas entradas de feedback
- **Funcionalidades**:
  - Sistema interativo de avaliação por estrelas
  - Carrossel horizontal para feedback de texto/áudio
  - Capacidades de gravação de voz
  - Validação e submissão de formulário

#### 5. RankingVC.swift

- **Propósito**: Exibir rankings e classificações
- **Funcionalidades**:
  - Visualização de pódio para os 3 primeiros colocados
  - Rankings segmentados (Funcionários, Locais, Eventos)
  - Sistema de pontuação baseado em pontos
  - Destaque do usuário atual

#### 6. StoreVC.swift

- **Propósito**: Resgate de pontos e recompensas
- **Funcionalidades**:
  - Catálogo de benefícios
  - Gerenciamento de saldo de pontos
  - Hub de navegação para criação de feedback

### Componentes Customizados

#### 1. SegmentedControl.swift

- Controle segmentado customizado com estilo da marca
- Padrão delegate para gerenciamento de seleção
- Suporta 3 segmentos: Funcionários, Locais, Eventos

#### 2. StarRatingView.swift

- Componente interativo de avaliação de 5 estrelas
- Seleção de avaliação baseada em toque
- Feedback visual com estrelas preenchidas/vazias

#### 3. ProfileHeader.swift

- Cabeçalho do perfil do usuário com avatar e informações
- Exibição de saldo e total de pontos
- Resumo de avaliação por estrelas

#### 4. Células de Table View

- **FeedbackTableViewCell**: Exibe feedback com avaliações e ícones de mídia
- **CollaboratorTableViewCell**: Item da lista de funcionários com cargo
- **RankingCell**: Entrada de ranking com posição e pontos
- **EmptyTableViewCell**: Mensagens de estado vazio

---

## 🗂️ Modelos de Dados

### Modelos Principais

#### Employee (Funcionário)

```swift
struct Employee: Identifiable, Codable {
    let id: String
    let email: String
    let password: String
    let name: String
    let cargo: String
    let image: String
    let qrCode: String
}
```

#### Feedback

```swift
class Feedback: Codable {
    let stars: Int
    let description: String
    let senderID: String
    let receiverID: String
    let midia: String?
}
```

#### Activity (Atividade)

```swift
struct Activity: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let averageRating: Double
    let date: Date
    let image: String
}
```

#### Resource (Recurso)

```swift
struct Resource: Identifiable, Codable {
    let id: String
    let type: String
    let name: String
    let averageRating: Double
    let photo: String
}
```

#### Benefit (Benefício)

```swift
struct Benefit: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let value: Int
}
```

---

## 🌐 Integração com API

### APIService.swift

O aplicativo se comunica com um backend em Go através de um serviço de API RESTful.

#### Configuração Base

```swift
static let shared = APIService(baseURL: URL(string: "https://seu-backend.com/api/")!)
```

#### Endpoints Disponíveis

| Método | Endpoint          | Propósito                       |
| ------ | ----------------- | ------------------------------- |
| GET    | `/employees`      | Buscar todos os funcionários    |
| GET    | `/employees/{id}` | Buscar funcionário específico   |
| GET    | `/feedbacks`      | Buscar todos os feedbacks       |
| POST   | `/feedbacks`      | Criar novo feedback             |
| GET    | `/resources`      | Buscar recursos de aprendizagem |
| GET    | `/activities`     | Buscar atividades da empresa    |
| GET    | `/benefits`       | Buscar benefícios disponíveis   |

#### Tratamento de Erros

```swift
enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingError(Error)
    case encodingError(Error)
}
```

---

## 🎨 Design UI/UX

### Paleta de Cores

O aplicativo usa um sistema de cores customizado definido em `Assets.xcassets`:

- **main-green**: Cor primária da marca (#25663C)
- **background-primary**: Fundo principal
- **background-secondary**: Fundos de cartões
- **label-primary**: Texto primário
- **segmentedControlSelected**: Cor do estado selecionado

### Tipografia

- **Fontes do sistema** com pesos variados (medium, semibold, bold)
- **Espaçamento consistente** usando sistema de grade de 4pt
- **Tamanhos de fonte amigáveis à acessibilidade**

### Hierarquia Visual

- **Tab Bar**: Navegação inferior com 5 seções principais
- **Navigation Bar**: Títulos grandes para telas principais
- **Cartões**: Contêineres com cantos arredondados para conteúdo
- **Controles Segmentados**: Alternância de seções dentro das telas

---

## 🔧 Funcionalidades Técnicas

### Integração com Câmera

- **Scanner de QR Code**: Scanner baseado em AVFoundation
- **Gerenciamento de Permissões**: Descrição de uso da câmera no Info.plist
- **Controles por Gestos**: Deslizar para dispensar a visualização da câmera

### Gerenciamento de Dados

- **Async/Await**: Concorrência moderna do Swift
- **Codificação/Decodificação JSON**: Implementação do protocolo Codable
- **Dados Mock Locais**: Dados de fallback para desenvolvimento

### Framework de UI

- **Protocolo ViewCode**: Construção programática de UI
- **Auto Layout**: Design responsivo baseado em constraints
- **Stack Views**: Arranjo flexível de conteúdo

### Navegação

- **UITabBarController**: Navegação principal do app
- **UINavigationController**: Navegação hierárquica
- **Apresentação Modal**: Telas overlay para tarefas específicas

---

## 🚀 Primeiros Passos

### Pré-requisitos

- Xcode 15.0+
- iOS 15.0+ como target de deployment
- Swift 5.0+

### Instalação

1. Clone o repositório
2. Abra `hackatona-project.xcodeproj` no Xcode
3. Configure a URL do backend em `APIService.swift`
4. Compile e execute o projeto

### Configuração

1. **Endpoint da API**: Atualize `baseURL` em `APIService.swift`
2. **Bundle ID do App**: Configure nas configurações do projeto
3. **Permissões da Câmera**: Verifique a descrição de uso da câmera no Info.plist

---

## 📋 Detalhamento das Funcionalidades

### 1. Tela de Perfil

- **Informações do Usuário**: Nome, cargo, avatar, avaliações
- **Histórico de Feedback**: Abas de feedback recebido e enviado
- **Sistema de Pontos**: Exibição de saldo e total de pontos
- **Estados Vazios**: Mensagens úteis quando não há feedback

### 2. Tela de Feedback

- **Três Categorias**: Funcionários, Recursos, Atividades
- **Funcionalidade de Busca**: Filtragem em tempo real
- **Seções Alfabéticas**: Navegação organizada de conteúdo
- **Navegação para Detalhes**: Tocar para visualizar/criar feedback

### 3. Câmera/Scanner

- **Detecção de QR Code**: Reconhecimento automático de códigos
- **Gerenciamento de URLs**: Abertura direta de links
- **UI Interativa**: Botão voltar e controles por gestos
- **Tratamento de Erros**: Gerenciamento de permissões e acesso à câmera

### 4. Tela de Ranking

- **Exibição de Pódio**: Representação visual dos 3 primeiros colocados
- **Alternância de Categorias**: Funcionários, Locais, Eventos
- **Rastreamento de Pontos**: Sistema de pontuação baseado em performance
- **Destaque do Usuário**: Identificação do usuário atual

### 5. Tela da Loja

- **Catálogo de Benefícios**: Recompensas disponíveis
- **Integração de Pontos**: Exibição de custos e validação
- **Hub de Navegação**: Acesso à criação de feedback

---

## 🧩 Padrões de Código

### Protocolo ViewCode

```swift
protocol ViewCodeProtocol {
    func addSubViews()
    func setupConstraints()
    func setup()
}
```

### Padrão Delegate

```swift
protocol NativeSegmentedDelegate: AnyObject {
    func didChangeSelection(to index: Int)
}
```

### Chamadas de API Assíncronas

```swift
func fetchEmployees() async throws -> [Employee] {
    return try await apiService.request("employees")
}
```

---

## 🐛 Problemas Conhecidos e Soluções

### Problemas Corrigidos

1. **Resolução de Nome de Usuário**: Corrigido endpoint da API de `/users/` para `/employees/`
2. **Exibição de Avaliação por Estrelas**: Corrigido espaçamento com distribuição `.fillEqually`
3. **Integração com API**: Resolvido conflitos entre callback vs async/await

### Limitações Atuais

1. **URL do Backend**: URL placeholder precisa de configuração de produção
2. **Autenticação**: Nenhum sistema de login implementado atualmente
3. **Carregamento de Imagens**: Referências de imagens locais precisam de suporte a URLs remotas

---

## 🔮 Melhorias Futuras

### Funcionalidades Planejadas

1. **Autenticação de Usuário**: Funcionalidade de login/logout
2. **Notificações Push**: Alertas de feedback em tempo real
3. **Upload de Imagens**: Anexos de fotos para feedback
4. **Suporte Offline**: Cache local de dados
5. **Analytics**: Rastreamento de engajamento do usuário

### Melhorias Técnicas

1. **Migração para SwiftUI**: Adoção de framework de UI moderno
2. **Core Data**: Persistência local de dados
3. **Testes Unitários**: Cobertura abrangente de testes
4. **Pipeline CI/CD**: Build e deployment automatizados

---

## 📖 Guia de Uso

### Para Desenvolvedores

#### Adicionando Novos View Controllers

1. Criar novo arquivo no diretório `ViewController/`
2. Implementar `ViewCodeProtocol` para configuração de UI
3. Adicionar ao `TabBarController.swift` se necessário como aba
4. Configurar navegação no view controller pai apropriado

#### Criando Componentes Customizados

1. Adicionar novo arquivo ao diretório `Components/`
2. Herdar da classe UIKit apropriada
3. Implementar métodos de configuração
4. Adicionar às views pai usando Auto Layout

#### Integração com API

1. Adicionar novos métodos de endpoint ao `APIService.swift`
2. Criar modelos de dados correspondentes em `Model/`
3. Implementar tratamento de erros
4. Usar padrão async/await para chamadas

### Para Usuários

#### Dando Feedback

1. Navegar para a aba **Feedback**
2. Selecionar categoria **Funcionários**
3. Tocar no funcionário desejado
4. Avaliar com estrelas e adicionar texto/áudio
5. Enviar feedback

#### Visualizando Rankings

1. Ir para a aba **Ranking**
2. Alternar entre categorias usando o controle segmentado
3. Ver pódio para os melhores performers
4. Rolar a lista para rankings completos

#### Usando o Scanner QR

1. Tocar na aba **Câmera**
2. Apontar câmera para o código QR
3. Seguir ações sugeridas
4. Deslizar para baixo para dispensar

---

## 🤝 Contributing

### Code Style

- Use **ViewCode** pattern for UI
- Follow **Swift naming conventions**
- Implement **error handling** for all API calls
- Add **comments** for complex logic

### Git Workflow

1. Create feature branch from main
2. Implement changes with tests
3. Submit pull request with description
4. Code review and merge
