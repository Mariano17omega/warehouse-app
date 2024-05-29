# Warehouse App

Este é um projeto de um gerenciador de armazém de aeroporto desenvolvido utilizando Ruby on Rails. O desenvolvimento deste projeto é baseado no curso "Ruby on Rails - Uma abordagem prática com TDD".

Aqui, vou compartilhar um resumo do passo a passo do desenvolvimento do projeto ao longo de todas as aulas.


## Criando o Projeto no GitHub

```
git init
git add .
git commit -m "Criação do projeto conflito"
git branch -M main
git remote add origin git@github.com:Mariano17omega/warehouse-app.git
git pull origin main --allow-unrelated-histories
git push -u origin main
```
 
Para atualizar as mudanças, basta utilizar:

```
git add .
git commit -m "NomeDoCommit"
git push
```

## Em casos de erro

Para resolver problemas como permissões ou reinstalação de gemas, você pode usar os seguintes comandos:

Remover permissão ROOT da pasta: `chmod -R 755 /home/omega/Rails/warehouse-app`

Reinstalar as gemas: `bundle clean --force `

# Aula 7 - Criando a Tela inicial 

## Criando o projeto Rails

`rails new warehouse-app --minimal --skip-test`

## Configurando o Bundle 

Adicione as gemas "rspec-rails" e "capybara" no grupo `:development` no Gemfile e execute:

```
bundle install
rails generate rspec:install
```

Configure o RSpec para testes do tipo sistema e o driver (`rack_test`) usado para os testes. No arquivo `rails_helper.rb`, adicione em `RSpec.configure`:

``` 
config.before(type: :system) do
  driven_by(:rack_test)
end
```

### Commit do Setup

```
git add .
git commit -m "Setup da aplicação pronto -  Aula 7"
```

## Criando o primeiro Test

Teste para a criação da Tela Inicial da aplicação.

Crie a pasta `system` e o arquivo `user_view_homepage_spec.rb` em `spec`:


```
require 'rails_helper'

describe 'Usuario visita tela inicial' do
  it 'e vê o nome do app' do
    # Arrange
    # Act
    visit('/')
    # Assert
    expect(page).to have_content('Galpões & Estoque')

  end 
end

```
### Solucionando primeiro Test

Criando uma Rota para : Adicione ```get '/', to: 'home#index'```  em `routes.rb`.

Criando o Controller:

- Criamos o controller para home: home_controller.rb

- Criamos a ação index no controller home

```
class ApplicationController < ActionController::Base
    def index
    end
end
```

Em seguida, crie uma view para o controller home. Crie a pasta `home` em `views` e, dentro dela, crie a view `index.html.erb`.

## Commit da aula 7

```
git add .
git commit -m "Primeio test para a view home - Aula 7"
git push
```

# Aula 8 - Listando Galpões 

## Criando o Teste

Crie um novo teste em `spec/system/user_view_homepage_spec.rb` para verificar se os galpões são listados na tela inicial:

```
it 'e vê os galpões cadrastrados' do
    # Arrange
    Werehouse.create(nome: 'Rio', code: 'SDU',  city: 'Rio de Janeiro', area: '60_000')
    Werehouse.create(nome: 'Maceio', code: 'MCZ',  city: 'Maceio', area: '50_000')

    # Act
    visit('/')
    # Assert
    expect(page).to have_content('Rio')
    expect(page).to have_content('SDU')
    expect(page).to have_content('Rio de Janeiro')
    expect(page).to have_content('60.000 m²')

    expect(page).to have_content('Maceio')
    expect(page).to have_content('MCZ')
    expect(page).to have_content('Maceio')
    expect(page).to have_content('50.000 m²')
  end 
  ```

## Solucionando o Teste

### Criando o Model

```rails generate model warehouse name:string code:string city:string area:integer```

Execute a migração:  ```rails db:migrate```

OBS: O nome do model deve ser sempre no singular e em inglês.

Para remover o aviso de alerta, apagamos a linha de pending no aquivo de teste unitario criando automaticamente na pasta spec.


### Listando Galpões na tela inicial


No `HomeController`, defina a variável na action index para receber a lista de todos os Galpões no banco de dados:


```@Warehouses= Warehouse.all```

Na view inicial, home/index.html.erb, fazemos a listagem usando essa variavel.

```
<h1>Galpões & Estoque</h1>

<h2>Galpões</h2>

<% @warehouses.each do |w|%>
    <%= w.name%>
    <%= w.code%>
    <%= w.city%>
    <%= w.area%> m²
<%end %>
```
## Commit da aula 8

```
git add .
git commit -m "Listando Galpões na tela inicial -  Aula 8"
git push
```

# Aula 9 - Listando Galpões (Parte 2)

## Criando o Teste

Adicione um teste para o caso de não existirem galpões cadastrados e modifique o teste existente para incluir essa verificação.


```
  it 'e não existe galpões cadastrados' do
    # Assert
    # Act
    visit('/')
    # Assert
    expect(page).to have_content('Não existem galpões cadastrados')
  end
```

Além disso, adicionamos esse caso no teste 'e vê os galpões cadrastrados' 

```expect(page).not_to have_content('Não existem galpões cadastrados')```

## Solucionando o Teste

Na pagina inicial, home, adicionamos:

```
<% if @warehouses.empty? %>
    <p>Não existem galpões cadastrados</p>
<%end %>
```

Para verificar o funcionamento, adicione um elemento ao banco de dados.

```
rails console

Warehouse.create(name: 'Rio', code: 'SDU',  city: 'Rio de Janeiro', area: '60000')
```

## Commit  da aula 9

```
git add .
git commit -m "Usuario vê galpões na tela inicial -  Aula 9"
git push
```
 

# Aula 10 - Detalhes de um galpão 

Queremos cria uma pagina para vê os detalhes de um galpão.

## Criando o Teste

Criamos um novo teste user_view_warehouse_details_spec.rb para acessar os detalhes de um galpão a partir da tela inicial:

```
require 'rails_helper'

describe 'Usuario vê detalhes de um galpão' do
    it 'e ve informações adicionais' do
        # Arrange
        Warehouse.create(name: 'Aeroporto SP', code: 'GRU',  city: 'Guarulhos', area: '100000', address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
    # Act
    visit('/')
    click_on('Aeroporto SP')
    # Assert
    expect(page).to have_content('Galpão GRU')
    expect(page).to have_content('Nome: Aeroporto SP')
    expect(page).to have_content('Cidade: Guarulhos')
    expect(page).to have_content('Área: 100000 m²')
    expect(page).to have_content('Endereço: Avenida do Aeroporto, 1000 CEP: 15000-000')
    expect(page).to have_content('Galpão destinado para cargas internacionais')
    end

end
```

## Solucionando o Teste

Adicionando Novos Atributos ao Banco de Dados.

```
rails generate migration add_address_to_warehouse address:string
```


```
rails generate migration add_attributes_to_warehouse cep:string description:string
rails db:migrate
```

Criando um CRUD de um Modelo.

Adicione em routes.rb: ```resources :warehouses, only: [:show]```

Para verificar as rotas criadas: ```rails routes```
 
Em home/index.html.erb, criamos um link para exibição dos detalhes de um galpão. Para gerar um link onde o texto do link é o texto do galpão e o link é o caminho de exibição dos detalhes do galpão, adicionamos:

```<%= link_to(w.name, warehouse_path(w.id) )%>```

Depois crie o controller para gerenciar as ações sobre Warehouse.

```
class WarehouseController < ApplicationController
    def show
    end
end
```

Depois crie a view `warehouses/show.html.erb` para essa action.

```
<h1>Galpão <%= @warehouse.code%></h1>
<h2> <%= @warehouse.description %> </h2>
<div>
  <strong>Nome: </strong><%= @warehouse.name%>
  <strong>Cidade: </strong><%= @warehouse.city%>
  <strong>Área: </strong><%= @warehouse.area%> m²
  <strong>Endereço: </strong><%= @warehouse.address%> <strong>CEP: </strong><%= @warehouse.cep%>

</div>
```

Depois definimos a variavel ```@warehouse =  Warehouse.find(params[:id])``` na action show.


```
class WarehouseController < ApplicationController
    def show
      @warehouse =  Warehouse.find(params[:id])
    end
end
```

## Commit da aula 10

```
git add .
git commit -m "Usuario vê detalhes de um galpão - Aula 10"
git push
```



# Aula 11 - Detalhes de um galpão (Parte 2)

Adicionamos o teste para o botão "Voltar" à tela inicial.

## Criando o Teste

Criamos o teste para o botão de Voltar a tela inicial.


```
it 'e volta para a tela inicial' do 
      # Arrange
      Warehouse.create(name: 'Aeroporto SP', code: 'GRU',  city: 'Guarulhos', area: '100000', address: 'Avenida do Aeroporto, 1000', cep: '15000-000', description: 'Galpão destinado para cargas internacionais')
      
      # Act
      visit '/'
      click_on 'Aeroporto SP'
      click_on 'Voltar'
      # Assert
      expect(current_path).to eq('/')

    end
```

## Solucionando o Teste

Adicionamos em warehouses/show.html.erb:

```<%= link_to 'Voltar', '/'%>```

Refatoramos o codigo para usar root invez de /. Em routes.rb, mudamos ```get '/', to: 'home#index'```  para ```root to: 'home#index'```

E trocamos '/' para root_path nos testes e em warehouses/show.html.erb.

## Commit da aula 11

```
git add .
git commit -m "Usuario vê galpões na tela inicial e volta para a tela inicial-  Aula 11"
git push
```


# Aula 12 - Melhorias no HTML

Melhoramos o HTML da pagina inicial home/index:

```
<section id="warehouse">
  <h2>Galpões</h2>

  <% @warehouses.each do |w|%>
    <div>
      <h3><%= link_to(w.name, warehouse_path(w.id) )%></h3>
      <dl>
        <dt>Código</dt>
        <dd><%= w.code%></dd>
        <dt>Cidade:</dt>
        <dd><%= w.city%></dd>
        <dt>Área:</dt>
        <dd><%= w.area%> m²</dd>        
      </dl>      
    </div>
  <%end %>

  <% if @warehouses.empty? %>
    <p>Não existem galpões cadastrados</p>
  <%end %>
</section>
```

Em \views\layouts\application.html.erb mudamos o body para:

```
  <body>
    <header> 
      <h1>Galpões & Estoque</h1>
    </header>
    <main>
      <%= yield %>
    </main>
  </body>
```

## Commit da aula 12

```
git add .
git commit -m "Melhorias no HTML - Aula 12"
git push
```

# Aula 13 - Introdução aos formulários

Apenas fundamendação teorica.

# Aula 14 - Cadastrando um galpão

## Criando o Teste

Criamos o teste para Cadastro um galpão.

```
require 'rails_helper'

describe 'Usuario cadastra um galpão' do
  it 'a partir da tela inicial' do
    # Arrange
    # Act
    visit root_path
    click_on 'Cadastrar Galpão'
    # Assert
    expect(page).to have_field 'Nome'
    expect(page).to have_field 'Descrição'
    expect(page).to have_field 'Código'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'CEP'
    expect(page).to have_field 'Área'
  end
end
```

## Solucionando o Teste

Adicionamos o link na tela inicial, em home/index

```
  <div>
  <%= link_to('Cadastra Galpão', new_warehouse_path ) %>
  </div>
```

Adicionamos a nova rota em routes:

```resources :warehouses, only: [:show, :new, :create]```

Adicionamos a action new em warehouses_controller

```
    def new
    end
```

Depois criamos uma view para a action new, nessa view fazemos o formulario:

```
<h1>Novo Galpãos</h1>

<%= form_with(model: Warehouse.new) do |f| %>
  <div>
    <%= f.label :name, 'Nome' %>
    <%= f.text_field :name%>
  </div>
  <div>
    <%= f.label :description, 'Descrição' %>
    <%= f.text_area :description%>
  </div>
  <div>
    <%= f.label :code, 'Código' %>
    <%= f.text_field :code%>
  </div>
  <div>
    <%= f.label :address, 'Endereço' %>
    <%= f.text_field :address%>
  </div>
  <div>
    <%= f.label :city, 'Cidade' %>
    <%= f.text_field :city%>
  </div>
  <div>
    <%= f.label :cep, 'CEP' %>
    <%= f.text_field :cep%>
  </div>
  <div>
    <%= f.label :area, 'Área' %>
    <%= f.number_field :area%>
  </div>
  <div>
    <%= f.submit 'Enviar' %>  
  </div>
<%end%>

```

Depois criamos a action create no controlle:

```
  def create
#    1 - Recebe os dados enviados 
    warehouse_params = params.require(:warehouse).permit( :name, :code, :city, :address, :description, :cep, :area)
    
#    2 - Cria um novo galpão no banco de dados
    w=Warehouse.new(warehouse_params)
    w.save()
#    3 - Redireciona para a tela inicial
    redirect_to root_path
  end
```

## Commit da aula 14

```
git add .
git commit -m "Formulario de Cadastro de um galpão - Aula 14"
git push
```

# Aula 15 - Flash Messages

Adicionamos Flash Messages para fornecer feedback ao usuário.

## Criando o Teste

No Assert do teste 'com sucesso' em user_register_warehouse_spec.rb, adicionamos a linha:


``` expect(page).to have_content 'Galpão cadastrado com sucesso.' ``` 

## Solucionando o Teste

Na action create do controle warehouses_controller, adicioamos a mensagem ```flash[:notice] = 'Galpão cadastrado com sucesso.' ``` antes do redirect_to root_path, ou adiciona junto ```redirect_to root_path, notice: 'Galpão cadastrado com sucesso.'```

Na pagina inicial, index.html.erb, adicionamos no inicio:

```
<div>
  <%= flash[:notice] %>
</div>
```
ou

```
<div>
  <%= notice %>
</div>
```

Para simplificar, podemos usar o notice em layouts\application.html.erb, inves do index.

## Commit da aula 15

```
git add .
git commit -m "Adicionando Flash Messages - Aula 15"
git push
```

# Aula 16 - Validação 

## Criando o Teste

Criamos um novo teste em user_register_warehouse_spec.rb:

```
  it 'com dados incompletos' do
    # Arrange
    # Act
    visit root_path
    click_on 'Cadastrar Galpão'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    click_on 'Enviar'
    # Assert
    expect(page).to have_content 'Galpão não cadastrado.' 
  end
```

## Solucionando o Teste

No modelo models\warehouse.rb, adicionamos a validação:

```validates :nome, :code, :city, :description, :address, :cep, :area, presence: true```

Na action create do warehouses_controller.rb, reescrevemos o trecho que cria um novo galpão no banco de dados e redireciona para a tela inicial.

```
    @warehouse = Warehouse.new(warehouse_params)
    if @warehouse.save()
      redirect_to root_path, notice: 'Galpão cadastrado com sucesso.' 
    else
      flash.now[:notice] = 'Galpão não cadastrado.' 
      render 'new'
    end
```
O render não suporta Flash Messages, então não podemos simplificar como em redirect_to.

OBS: Não esquecer de usar aspas no new!

Na action new instanciamos a variavel ```@warehouse = Warehouse.new()``` para substitui ```Warehouse.new``` por ```@warehouse``` no formulario new.html.erb. 

Dessa forma, quando um galpão for cadastrado com dados incompletos, a pagina vai ser atualizada aparecendo uma mensagem e as informações já digitadas no formulario.

OBS: Corrigir os testes anteriores onde usamos informações incompletas nos formularios.

## Commit da aula 16

```
git add .
git commit -m "Validação - Aula 16"
git push
```

# Aula 17 - Testes unitários

Escrevemos testes unitários para validar os campos do modelo.

## Criando o Teste

Em spec\models\warehouse_spec.rb, escrevemos os testes para verificar a validação de todos os campos.

```
require 'rails_helper'

RSpec.describe Warehouse, type: :model do
  describe '#valid?' do
    context 'Apresenta' do
      it 'Falso quando o name está vazio' do
        # Assert
        warehouse = Warehouse.new(name: '', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')

        # Act 
        result = warehouse.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o code está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: '',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false        
      end

      it 'Falso quando a city está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: '', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end

      it 'Falso quando a area está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o address está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: ''  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o cep está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end

      it 'Falso quando a description está vazio' do
        # Assert
        warehouse = Warehouse.new(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: '')
    
        # Act 
        result = warehouse.valid?
    
        # Assert
        expect(result).to eq false
      end
    end

    context 'Apresenta' do

      it 'Falso quando o CODE já está sendo usado' do
        # Assert
        first_warehouse = Warehouse.create(name: 'RIO', code: 'SDU',  city: 'Rio de Janeiro', area: '60000', address: 'Ilha do Governador'  , cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')
                    
      second_warehouse = Warehouse.new(name: 'Maceio', code: 'SDU',  city: 'Maceio', area: '50000', address: 'Tabuleiro do Pinto, Rio Largo' , cep: '57100-000' , description: 'Galpão do aeroporto Internacional de Maceió' )

        # Act 
        result = second_warehouse.valid?

        # Assert
        expect(result).to eq false  
      end
    end

  end
end
```

Para testes de instancia, usamos ```'#valid?'```.

Podemos usar a simplificação ```expect(warehouse).not_to be_valid``` para simplificar as linhas:

```
result = warehouse.valid?
expect(result).to eq false  
```

## Solucionando o Teste

Depois em app\models\warehouse.rb, adicionamos a validação ```validates :code, uniqueness: true``` para que o código seja de uso único.

## Commit da aula 17

```
git add .
git commit -m "Testes unitários - Aula 17"
git push
```

# Aula 18 - i18n
Implementando internacionalização i18n

Em config/locales criamos o arquivo pt-BR.yml com 

```
pt-BR:
  hello: 'Olá Mundo'
```

Para definir o pt-BR como o padrão, em config/initializers, criamos o arquivo locale.rb e escrevemos: 

```
I18n.available_locales = [:en, :'pt-BR']

I18n.default_locale = :'pt-BR'
```

Para verificar o funcionamento, adicionamos o sequinte parágrafo na view de home:

```
  <p>
    <%=I18n.translate('hello')%>
  </p>

```

Após usar .valid? para fazer a validação de um cadastro com informações incompletas, é possivel visualizar as mensagens de erro usando o metodo .errors.full_messages. Essas mensagens são geradas pelo proprio Rails e estão em inglês.

Removendo os nomes dos campos no formulario de cadastro, o texto dos campos passam a ser os nomes dos atributos que estão sendo inseridos (name, description, code, etc.) e inves de exibir submit, o botão de enviar passa a ter o texto Create Warehouse.

```
<h1>Novo Galpãos</h1>

<%= form_with(model: @warehouse ) do |f| %>
  <div>
    <%= f.label :name %>
    <%= f.text_field :name%>
  </div>
  <div>
    <%= f.label :description %>
    <%= f.text_area :description%>
  </div>
  <div>
    <%= f.label :code %>
    <%= f.text_field :code%>
  </div>
  <div>
    <%= f.label :address %>
    <%= f.text_field :address%>
  </div>
  <div>
    <%= f.label :city %>
    <%= f.text_field :city%>
  </div>
  <div>
    <%= f.label :cep %>
    <%= f.text_field :cep%>
  </div>
  <div>
    <%= f.label :area  %>
    <%= f.number_field :area%>
  </div>
  <div>
    <%= f.submit   %>  
  </div>
<%end%>

```

A gem rails-i18n fornecer um conjunto mais completo de tradução para diferentes localidades. Para instalar apenas o pacote de pt-BR, baixamos o arquivo pt-BR.yml de <a href="<%=  https://github.com/svenfuchs/rails-i18n/tree/master/rails/locale/ %>">rails-i18n/a>, depois salvamos o arquivo na pasta locales.

Com isso, o botão de enviar passa a ter o texto Criar Warehouse inves de Create Warehouse.
 
Em config/locales criamos o arquivo models.yml com a tradução do model e de seus atributos:

```
pt-BR:
  activerecord:
    models:
      warehouse: 'Galpão'
    attributes:
      warehouse:
        name: 'Nome'
        code: 'Código'
        description: 'Descrição'
        city: 'Cidade'
        area: 'Área'
        address: 'Endereço'
        cep: 'CEP'

```
Assim, inves de aparecer name, description, code, etc. nas mensagens de erro geradas pelo rails e na exibição, quando não definimos um nome para o campo, como visto anteriomente, agora o Rails vai usar os nomes traduzidos sempre que for exibi-los para o usuario.

Para visualizar as mensagens de erro, abrimos o Rails console e tentamos cadastrar um galpão com todos os atribudos vazios:

```
warehouse = Warehouse.new(name: '', code: '',  city: '', area: '', address: ''  , cep: '' , description: '')

warehouse.valid? 

warehouse.errors.full_messages
```

Oresultado de warehouse.errors.full_messages é uma lista com os erros usando os nomes traduzidos de models.yml.

```
["Nome não pode ficar em branco",
 "Código não pode ficar em branco",
 "Cidade não pode ficar em branco",
 "Descrição não pode ficar em branco",
 "Endereço não pode ficar em branco",
 "CEP não pode ficar em branco",
 "Área não pode ficar em branco"]
```


## Criando o Teste

Queremos que sejam exibidas as mensagens de erro quando o usuario tenta cadastrar um galpão invalido.

Adicionando mais alguns testes em ser_register_warehouse_spec.rb para quando tivemos dados incompletos.

```
expect(page).to have_content 'Nome não pode ficar em branco'
expect(page).to have_content 'Código não pode ficar em branco'
expect(page).to have_content 'Cidade não pode ficar em branco'
expect(page).to have_content 'Descrição não pode ficar em branco'
expect(page).to have_content 'Endereço não pode ficar em branco"'
expect(page).to have_content 'CEP não pode ficar em branco'
expect(page).to have_content 'Área não pode ficar em branco'
```

## Solucionando o Teste

Na tela de cadastro, view new.html.erb, adicionamos no inicio:

```
<% if @warehouse.errors.any? %>
<p> Verifique os erros abaixo: </p>
<ul>
  <%@warehouse.errors.full_messages.each do |msg|%>
    <li> <%= msg %></li>
  <%end%>
</ul>
<%end%>
```

## Commit da aula 18

```
git add .
git commit -m "Implementando internacionalização i18n - Aula 18"
git push
```




# Aula 19 - Editar galpão


## Criando Teste para Editar galpão 

Criamos o arquivo user_edit_warehouse_spec.rb em spec/system e ecrevemos um novo teste.

```
require 'rails_helper'

describe 'Usuario edita um galpão' do
  it 'a partir da tela inicial' do
    # Arrange
    warehouse = Warehouse.create!(name: 'Rio', code: 'SDU',  city: 'Rio de Janeiro', area: '60000',
                address: 'Ilha do Governador', cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')

    # Act
    visit root_path
    click_on 'Rio'
    click_on 'Editar'
    # Assert
    expect(page).to have_content 'Editar Galpão'

    expect(page).to have_field 'Nome', with: 'São Paulo'
    expect(page).to have_field 'Descrição', with: 'Aeroporto de SP'
    expect(page).to have_field 'Código' , with: 'ASP'
    expect(page).to have_field 'Endereço' , with: 'Em algum lugar de São Paulo'
    expect(page).to have_field 'Cidade', with: 'São Paulo'
    expect(page).to have_field 'CEP' , with: '2343-545'
    expect(page).to have_field 'Área', with: '660066'
  end

end

```

Onde with verifica o valor preenchido no campo do formulario.


## Solucionando o Teste

Em routes, adicionamos mais duas rotas em resources:

``` resources :warehouses, only: [:show, :new, :create, :edit, :update] ```

Na view warehouses/show.html.erb, adicionamos o botão de editar:

``` <%= link_to 'Editar', edit_warehouse_path( @warehouse.id ) %> ```

Em seguida, criamos a action edit em warehouses_controller.rb e sua respectiva view, edit.html.erb.

 
```   
def edit  
  @warehouse =  Warehouse.find(params[:id])
end
```

Copiamos o codigo do formulario de new.html.erb para edit.html.erb. para reaproveitar o codigo do formulario de cadastro.


## Criando Teste para a edição com Sucesso

Adicionamos um teste para avaliar o cadastro com sucesso.

```   
it 'com sucesso' do
  # Arrange
  warehouse = Warehouse.create!(name: 'Rio', code: 'SDU',  city: 'Rio de Janeiro', area: '60000',
                address: 'Ilha do Governador', cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')

  # Act
  visit root_path
  click_on 'Rio'
  click_on 'Editar'

  fill_in 'Nome',	with: 'São Paulo'
  fill_in 'Cidade',	with: 'São Paulo'
  fill_in 'Endereço',	with: 'Avenida qualquer'
  fill_in 'Área',	with: '6666666'
  click_on 'Enviar'
  # Assert
  expect(page).to have_content 'Galpão Atualizado com sucesso'
  expect(page).to have_content 'Nome: São Paulo'
  expect(page).to have_content 'Área: 6666666 m²'
  expect(page).to have_content 'Endereço: Avenida qualquer'
  expect(page).to have_content 'Cidade: São Paulo'
end
```
## Solucionando o Teste

Em warehouses_controller.rb, adicionamos a action:

```
def update
  warehouse_params = params.require(:warehouse).permit( :name, :code, :city, :address, :description, :cep, :area)
  @warehouse =  Warehouse.find(params[:id])
  @warehouse.update(warehouse_params)

  redirect_to warehouse_path(  @warehouse.id ), notice: 'Galpão Atualizado com sucesso'
end
```


## Criando Teste para os campos obrigadorios na edição

```
it 'e mantem os campos obrigadorios' do
  # Arrange
  warehouse = Warehouse.create!(name: 'Rio', code: 'SDU',  city: 'Rio de Janeiro', area: '60000',
              address: 'Ilha do Governador', cep: '21941-900' , description: 'Galpão do aeroporto Santos Dumont, no Rio de Janeiro')

  # Act
  visit root_path
  click_on 'Rio'
  click_on 'Editar'

  fill_in 'Nome',	with: ''
  fill_in 'Cidade',	with: 'São Paulo'
  fill_in 'Endereço',	with: ''
  fill_in 'Área',	with: ''
  click_on 'Enviar'
  # Assert
  expect(page).to have_content 'Não foi possivel atualizar o galpão' 
end
```

## Solucionando o Teste

Atualizamos a action update

```
  def update
    warehouse_params = params.require(:warehouse).permit( :name, :code, :city, :address, :description, :cep, :area)

    @warehouse =  Warehouse.find(params[:id])
    if @warehouse.update(warehouse_params)
      redirect_to warehouse_path(  @warehouse.id ), notice: 'Galpão Atualizado com sucesso'
    else
      flash[:notice] = 'Não foi possivel atualizar o galpão.'
      render 'edit'
    end
  end
```

## Commit da aula 19

```
git add .
git commit -m "Editar galpão - Aula 19"
git push
```

# Aula 20 - Removendo repetições no código

Criamos um metodo privato em warehouses_controller.rb para não repetir o mesmo codigo nas actions

```
private

def set_warehouse
  @warehouse =  Warehouse.find(params[:id])
end

def warehouse_params
  params.require(:warehouse).permit( :name, :code, :city, :address, :description, :cep, :area)    
end
```

Usando ```before_action :set_warehouse, only: [:show, :edit, :update]``` no incio de warehouses_controller.rb, o metodo set_warehouse é iniciado nos metodos show, edit e update.

Usando Patials views, crie um arquivo _form.html.erb com o mesmo formulario das views edit e new.

```
<%= form_with(model: @warehouse ) do |f| %>
  <div>
    <%= f.label :name %>
    <%= f.text_field :name%>
  </div>
  <div>
    <%= f.label :description %>
    <%= f.text_area :description%>
  </div>
  <div>
    <%= f.label :code %>
    <%= f.text_field :code%>
  </div>
  <div>
    <%= f.label :address%>
    <%= f.text_field :address%>
  </div>
  <div>
    <%= f.label :city%>
    <%= f.text_field :city%>
  </div>
  <div>
    <%= f.label :cep %>
    <%= f.text_field :cep%>
  </div>
  <div>
    <%= f.label :area  %>
    <%= f.number_field :area%>
  </div>
  <div>
    <%= f.submit 'Enviar' %>   
  </div>
<%end%>

```

OBS: Uma  Patial view sempre começa com _.

Nas views edit e new de warehouses_controller.rb, removemos o formulario e colocamos ``` <%= render 'form'%> ```.

## Commit da aula 20

```
git add .
git commit -m "Removendo repetições no código- Aula 20"
git push
```
 

# Aula 21 - Apagando galpões

## Criando o Teste

```

describe 'Usuario remove um galpão' do
  it 'Com sucesso' do
    # Arrange
    Warehouse.create(name: 'Maceio', code: 'MCZ',  city: 'Maceio', area: '50000', address: 'Tabuleiro do Pinto, Rio Largo' , cep: '57100-000' , description: 'Galpão do aeroporto Internacional de Maceió' )

    # Act
    visit root_path
    click_on 'Maceio'
    click_on 'Remover'
    # Assert
    expect(current_path).to eq root_path
    expect(page).to have_content 'Galpão removido com sucesso'
    expect(page).not_to have_content 'Maceio'
    expect(page).not_to have_content 'MCZ'

  end
end

```

## Solucionando o Teste


Em routes adicionamos a rota destroy em resources.

```
resources :warehouses, only: [:show, :new, :create, :edit, :update, :destroy]
```

Em views/warehouses/show.html.erb, adicionamos 


``` 
<%= button_to 'Remover', warehouse_path(@warehouse.id), method: :delete %>
```
 
Em warehouses_controller.rb acicionamos a action 

``` 
def destroy
  @warehouse.destroy
  redirect_to root_path, notice: 'Galpão removido com sucesso'
end
```

e incluimos destroy em before_action.

## Commit da aula 21

```
git add .
git commit -m "Apagando galpões - Aula 21"
git push
```

# Aula 22 - CRUD de Fornecedores


## Criando os Testes


Em spec/system/suppliers/user_view_suppliers_spec.rb :

```
require 'rails_helper'

describe 'Usuario vê fornecedores' do
  it 'a partir do menu' do
    #  Arrange
    #  Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end
    #  Assert
    expect(current_path).to eq suppliers_path
  end

  it 'com sucesso' do
    #  Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                    full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

    Supplier.create!(corporate_name: 'Spark Industires LTDA', brand_name: 'Spark', registration_number: '52654414000138',
                    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato_spark@spark.com' )
    #  Act
    visit root_path
    click_on 'Fornecedores'
    #  Assert
    expect(page).to have_content 'Fornecedores'
    expect(page).to have_content 'ACME'
    expect(page).to have_content 'Bauru - SP'

    expect(page).to have_content 'Spark'
    expect(page).to have_content 'Teresina - PI'
  end

  it 'e não existem fornecedores cadastrados' do
    #  Arrange
    #  Act
    visit root_path
    within('nav') do
      click_on 'Fornecedores'
    end
    #  Assert
    expect(page).to have_content 'Não existem fornecedores cadastrados.'
  end

end

```

Em spec/system/suppliers/user_view_supplier_details_spec.rb:

```
require 'rails_helper'

describe 'Usuario vê detalhes do fornecedore' do
  it 'a partir da tela inicial' do
    #  Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                    full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )
    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    #  Assert
    expect(page).to have_content 'ACME LTDA'
    expect(page).to have_content 'Documento: 29452204000145'
    expect(page).to have_content 'Endereço: Av das Plamas, 100 - Bauru - SP'
    expect(page).to have_content 'Email: contato@acme.com'

  end

  it 'e volta para a tela inicial' do
    #  Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                    full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )
    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACME'
    click_on 'Voltar'
    #  Assert
    expect(current_path).to eq suppliers_path

  end


end

```



Em spec/system/suppliers/user_register_supplier_spec.rb:
```
require 'rails_helper'

describe 'Usuario cadastra um fornecedor' do
  it 'a partir do menu' do
    #  Arrange
    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'
    #  Assert
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'Razão Social'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'
    expect(page).to have_field 'E-mail'


  end

  it 'com sucesso' do
    #  Arrange
    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'

    fill_in 'Nome Fantasia',	with: 'ACME'
    fill_in 'Razão Social',	with: 'ACME LTDA'
    fill_in 'CNPJ',	with: '29452204000145'
    fill_in 'Endereço',	with: 'Av das Plamas, 100'
    fill_in 'Cidade',	with: 'Bauru'
    fill_in 'Estado',	with: 'SP'
    fill_in 'E-mail',	with: 'contato@acme.com'
    click_on 'Enviar'

    #  Assert
    expect(current_path).to eq suppliers_path
    expect(page).to have_content 'Fornecedor cadastrado com sucesso.'
    expect(page).to have_content 'ACME'
    expect(page).to have_content 'Bauru - SP'

  end


  it 'com dados incopletos' do
    #  Arrange
    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Cadastrar novo fornecedor'

    fill_in 'Nome Fantasia',	with: ''
    fill_in 'Razão Social',	with: ''
    fill_in 'CNPJ',	with: ''
    fill_in 'Endereço',	with: 'Av das Plamas, 100'
    fill_in 'Cidade',	with: 'Bauru'
    fill_in 'Estado',	with: 'SP'
    fill_in 'E-mail',	with: 'contato@acme.com'
    click_on 'Enviar'

    #  Assert
    expect(page).to have_content 'Fornecedor não cadastrado'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
  end
end


```

Em spec/system/suppliers/user_edit_supplier_spec.rb:

```
require 'rails_helper'

describe 'Usuario Editar um fornecedor' do
  it 'a partir do menu' do
    #  Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACMES', registration_number: '29452204000145',
    full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACMES'
    click_on 'Editar'
    #  Assert
    expect(page).to have_field 'Nome Fantasia'
    expect(page).to have_field 'Razão Social'
    expect(page).to have_field 'CNPJ'
    expect(page).to have_field 'Endereço'
    expect(page).to have_field 'Cidade'
    expect(page).to have_field 'Estado'
    expect(page).to have_field 'E-mail'

  end

  it 'com sucesso' do
    #  Arrange
    Supplier.create!(corporate_name: 'ACME LTDA', brand_name: 'ACMES', registration_number: '29452204000145',
    full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'ACMES'
    click_on 'Editar'

    fill_in 'Nome Fantasia',	with: 'STARK'
    fill_in 'Razão Social',	with: 'STARK Industires LTDA'
    fill_in 'Endereço',	with: 'Nova York, T10'
    fill_in 'Cidade',	with: 'Nova York'
    fill_in 'Estado',	with: 'NY'
    fill_in 'E-mail',	with: 'contato@stark.com'
    click_on 'Enviar'

    #  Assert
    #expect(current_path).to eq root_path
    expect(page).to have_content 'Fornecedor editado com sucesso.'
    expect(page).to have_content 'STARK Industires LTDA'
    expect(page).to have_content 'Documento: 29452204000145'
    expect(page).to have_content 'Endereço: Nova York, T10 - Nova York - NY'
    expect(page).to have_content 'contato@stark.com'

  end


  it 'com dados incopletos' do
    #  Arrange
    Supplier.create!(corporate_name: 'Spark Industires LTDA', brand_name: 'Spark', registration_number: '52654414000138',
    full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato_spark@spark.com' )

    #  Act
    visit root_path
    click_on 'Fornecedores'
    click_on 'Spark'
    click_on 'Editar'

    fill_in 'Nome Fantasia',	with: ''
    fill_in 'Razão Social',	with: ''
    fill_in 'Endereço',	with: 'Nova York, T10'
    fill_in 'Cidade',	with: 'Nova York'
    fill_in 'Estado',	with: 'NY'
    fill_in 'E-mail',	with: 'contato@stark.com'
    fill_in 'CNPJ',	with: ''
    click_on 'Enviar'

    #  Assert
    expect(page).to have_content 'Não foi possível editar o Fornecedor'
    expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
    expect(page).to have_content 'Razão Social não pode ficar em branco'
    expect(page).to have_content 'CNPJ não pode ficar em branco'
  end
end

```

Em spec/models/supplier_spec.rb:

```
require 'rails_helper'

RSpec.describe Supplier, type: :model do
  describe '#valid?' do
    context 'Apresenta' do
      it 'Falso quando o corporate_name está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: '', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o brand_name está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: '', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o registration_number está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o full_address está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: '', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o city está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: '', state: 'SP', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o state está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: '', email: 'contato@acme.com' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end

      it 'Falso quando o email está vazio' do
        # Assert
        supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
        full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: '' )

        # Act
        result = supplier.valid?

        # Assert
        expect(result).to eq false
      end


      context 'Apresenta' do

        it 'Falso quando o corporate_name já está sendo usado' do
          # Assert
          first_supplier= Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                                          full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

          second_supplier =Supplier.new(corporate_name: 'ACME LTDA', brand_name: 'Spark', registration_number: '52654414000138',
                                            full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato_spark@spark.com' )

          # Act
          # Assert
          expect(second_supplier).not_to be_valid
        end
        it 'Falso quando o email já está sendo usado' do
          # Assert
          first_supplier= Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                                          full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

          second_supplier =Supplier.new(corporate_name: 'Spark Industires LTDA', brand_name: 'Spark', registration_number: '52654414000138',
                                            full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato@acme.com' )

          # Act
          # Assert
          expect(second_supplier).not_to be_valid
        end

        it 'Falso quando o brand_name já está sendo usado' do
          # Assert
          first_supplier= Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                                          full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

          second_supplier =Supplier.new(corporate_name: 'Spark Industires LTDA', brand_name: 'ACME', registration_number: '52654414000138',
                                            full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato_spark@spark.com' )

          # Act
          # Assert
          expect(second_supplier).not_to be_valid
        end

        it 'Falso quando o registration_number já está sendo usado' do
          # Assert
          first_supplier= Supplier.create(corporate_name: 'ACME LTDA', brand_name: 'ACME', registration_number: '29452204000145',
                                          full_address: 'Av das Plamas, 100', city: 'Bauru', state: 'SP', email: 'contato@acme.com' )

          second_supplier =Supplier.new(corporate_name: 'Spark Industires LTDA', brand_name: 'Spark', registration_number: '29452204000145',
                                            full_address: 'Torre da Indústria, 1', city: 'Teresina', state: 'PI', email: 'contato_spark@spark.com' )

          # Act
          # Assert
          expect(second_supplier).not_to be_valid
        end

      end

    end
  end
end

```


## Solucionando os Testes

Geramos o modelo para os fornecedores:

```
rails generate model Supplier corporate_name:string brand_name:string registration_number:integer full_address:string  city:string  state:string  email:string 
rails db:migrate
```

Criamos as rotas:

``` resources :suppliers, only:  [:show, :new, :create, :edit, :update, :index] ```

Criando o Controller:

```
class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :edit, :update]

  def index
    @suppliers= Supplier.all
  end

  def show; end

  def new
    @supplier = Supplier.new()
  end


  def create
    # 1 - Recebe os dados enviados
    #supplier_params

    # 2 - Cria um novo galpão no banco de dados
    @supplier = Supplier.new(supplier_params)

    #    3 - Redireciona para a tela inicial
        if @supplier.save()
          redirect_to suppliers_path, notice: 'Fornecedor cadastrado com sucesso.'
        else
          flash.now[:notice] = 'Fornecedor não cadastrado.'
          render 'new'
        end
      end

      def edit; end

      def update
        #supplier_params

        if @supplier.update(supplier_params)
          redirect_to supplier_path(  @supplier.id ), notice: 'Fornecedor editado com sucesso.'
        else
          flash[:notice] = 'Não foi possível editar o Fornecedor.'
          render 'edit'
        end
      end

      private

      def set_supplier
        @supplier =  Supplier.find(params[:id])
      end

      def supplier_params
        params.require(:supplier).permit( :corporate_name, :brand_name, :registration_number, :full_address,
                       :city, :state, :email)
      end

end

```

Criando as views do suppliers_controller.rb.

Em views/layouts/application.html.erb, adicionamos no header:

```
<nav>
  <%= link_to 'Fornecedores', suppliers_path%>
</nav>

```

Criando a view /suppliers/index.html.erb: 

```
<section id="fornecedores">
  <h2>Fornecedores</h2>
  <div>
  <%= link_to('Cadastrar novo fornecedor', new_supplier_path ) %>
  </div>

  <%if @suppliers.any?%>
    <table>
      <thead>
        <tr>
          <th> Nome </th>
          <th> Localização </th>
        </tr>
      </thead>
      <tbody>
        <%@suppliers.each do |s|%>
        <tr>
          <td><%= link_to s.brand_name, s%></td>
          <td><%= s.city%> - <%= s.state%></td>
        </tr>
        <%end%> 

      </tbody>
    </table>
  <%end%>

  <% if @suppliers.empty? %>
    <p> Não existem fornecedores cadastrados. </p>
  <%end %>
</section>
```

Criando a view suppliers/show.html.erb: 

```
<h1>Fornecedor <%= @supplier.brand_name%></h1>
<h2> <%= @supplier.corporate_name %> </h2>
<dl>
  <dt>Documento: </dt>
  <dd><%= @supplier.registration_number%></dd>
  <dt>Endereço: </dt>
  <dd><%= @supplier.full_address%> - <%= @supplier.city%> - <%= @supplier.state%></dd>
  <dt>Email: </dt>
  <dd><%= @supplier.email%></dd>
</dl>

<div>
  <%= link_to 'Editar', edit_supplier_path( @supplier.id ) %>
</div>

<div>
  <%= link_to 'Voltar', suppliers_path%>
</div>

```

Criando a view suppliers/new.html.erb: 

```
<h1>Novo Fornecedor</h1>

<% if @supplier.errors.any? %>
<p> Verifique os erros abaixo: </p>
<ul>
  <%@supplier.errors.full_messages.each do |msg|%>
    <li> <%= msg %></li>
  <%end%>
</ul>
<%end%>


<%= render 'form'%>

```

Criando o Formulario da view, suppliers/_form.html.erb : 

```
<%= form_with(model: @supplier ) do |f| %>
  <div>
    <%= f.label :corporate_name %>
    <%= f.text_field :corporate_name%>
  </div>
  <div>
    <%= f.label :brand_name %>
    <%= f.text_area :brand_name%>
  </div>
  <div>
    <%= f.label :registration_number %>
    <%= f.number_field :registration_number%>
  </div>
  <div>
    <%= f.label :full_address%>
    <%= f.text_field :full_address%>
  </div>
  <div>
    <%= f.label :city%>
    <%= f.text_field :city%>
  </div>
  <div>
    <%= f.label :state %>
    <%= f.text_field :state%>
  </div>
  <div>
    <%= f.label :email  %>
    <%= f.email_field :email%>
  </div>
  <div>
    <%= f.submit 'Enviar' %>   
  </div>
<%end%>

```


Criando a view suppliers/edit.html.erb: 

```
<h1>Editar Fornecedor</h1>

<% if @supplier .errors.any? %>
<p> Verifique os erros abaixo: </p>
<ul>
  <%@supplier .errors.full_messages.each do |msg|%>
    <li> <%= msg %></li>
  <%end%>
</ul>
<%end%>

<%= render 'form'%>
```

Fazendo a localização em config/locales/models.yml, adicionamos:

```
supplier:
  corporate_name: 'Razão Social'
  brand_name: 'Nome Fantasia'
  registration_number: 'CNPJ'
  full_address: 'Endereço'
  city: 'Cidade'
  state: 'Estado'
  email: 'E-mail'
         
```


## Commit da aula 22

```
git add .
git commit -m "CRUD de Fornecedores - Aula 22"
git push
```

fazer atalhos de comados no git


**Commit**

```
git add .
git commit -m "Commit_texto"
git push
```



**Criando o Model:**

```rails generate model nome_model name:string area:integer event:references```

**Migração:**

https://guides.rubyonrails.org/active_record_migrations.html


```rails generate migration AddExtrasToOrders extra_fee_discount_description:string payment_method_used:string```

 ```rails db:migrate```

**Criação de User usando Devise:**

```rails generate devise userclient```







