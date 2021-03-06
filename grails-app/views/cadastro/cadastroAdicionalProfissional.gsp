<%@page import="br.com.udoctor.tipo.Enum.UsuarioType"%>
<html>
<head>
<title>Dados Adicionais Profissional</title>
<meta name="layout" content="principal"/>
<parameter name="searchbarAtivo" value="X" /> 
<r:require module="core"/>
<r:script>
$(document).ready(function() {
$('#dataDeNascimento').datepicker({
format: "dd/mm/yyyy",
autoclose: true,
language:"pt-BR",
weekStart: 1
});
});
</r:script >
</head>
<body>

	<div id="breadcrumb">
		<div class="container">
			<h2>Editar perfil</h2>
			<div id="breadcrumb-info"><i class="icon-briefcase"></i> Profissional <span>&raquo;</span> <g:link controller='profile' action="index">Visualizar perfil</g:link></div>
		</div>
	</div>
	
	<g:if test="${salvoComSucessoCA == false}">
	<div class="alert alert-warning">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
    	<g:renderErrors beans='[usuario:"${usuario}", profissional:"${profissional}"]' as="list" />

        <g:each in="${validacaoArquivos}" var ="validacaoArquivo">
            ${validacaoArquivo?.value} <br/>
        </g:each>

   		<g:each in="${enderecos}" var="endereco">
    		<g:renderErrors bean="${endereco}"/>
    	</g:each>
    	
    	<g:each in="${links}" var="link">
    		<g:renderErrors bean="${link}"/>
   		</g:each>
   		
    	<g:each in="${telefones}" var="telefone">
    		<g:renderErrors bean="${telefone}"/>
    	</g:each>
    </div>
	</g:if>
	
	<g:if test="${salvoComSucessoCA}">
	<div class="alert alert-success">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		Profile atualizado com sucesso!<br>
	</div>
	</g:if>
	
	<g:if test="${salvoComSucessoCI}">
	<div class="alert alert-success">
		<button type="button" class="close" data-dismiss="alert">&times;</button>
		Cadastro inicial realizado com sucesso!!<br>
	</div>
	</g:if>
	
	<g:form action="cadastroAdicionalProfissional" method="POST"
			name="cadastroAdicionalProfissional" class="container content" enctype="multipart/form-data" >
			
		<div id="left-fields" class="content-left">

            <g:set var="usuarioComAvatar" value="${arquivos && arquivos.size() == 2}" />
			<g:render template="/templatesCadastroUsuario/avatar" model="['usuarioComAvatar': usuarioComAvatar, 'tipoUsuario': UsuarioType.PROFISSIONAL, 'templateAvatar': 'avatar-doctor.png', 'arquivos': arquivos]"/> 
			
			<h5>
				<i class="icon-plus-sign"></i> Plano(s) de saúde: 
				<a class="help" href="" title="Plano de saúde:" data-content="Faltou algum plano de saúde? <strong>Clique e faça uma sugestão</strong>.">[?]</a>
			</h5>
			<g:render template="/templatesCadastroUsuario/planosDeSaude" model="['planosDeSaude': planosDeSaude, 'planosDeSaudeUtilizados': planosDeSaudeUtilizados]"/> 

			<h5>
				<i class="icon-phone"></i> Telefone(s):
			</h5>			
			<g:render template="/templatesCadastroUsuario/telefones" model="['telefones': telefones]"/> 

			<h5>
				<i class="icon-map-marker"></i> Endereço(s):
			</h5>
			<g:render template="/templatesCadastroUsuario/enderecos" model='["enderecos": enderecos, "estados": estados, "tipoUsuario": "${UsuarioType.PROFISSIONAL}"]'/> 

		    <h5>
		    	<i class="icon-globe"></i> Link(s):
		    </h5> 
		    <g:render template="/templatesCadastroUsuario/links" model="['links': links]"/> 
		</div>

		<div class="content-middle profile-info">
			<h1>Dados pessoais</h1>

			<label class="form-field pull-left">
				Nome:<br>
				<g:textField name="nome" id="nome" value="${usuario?.nome}"/>
			</label>

			<label class="form-field pull-right">
				Sobrenome:<br>
				<g:textField name="sobrenome" id="sobrenome" value="${usuario?.sobrenome}"/>
			</label>

			<label class="form-field pull-left">
				E-mail:<br>
				<g:textField name="email" id="email" value="${usuario?.email}"/>
			</label>
			
			<label class="form-field pull-right">
				Gênero:<br>
				<g:render template="/templatesCadastroUsuario/genero" model="['genero': profissional?.genero]"/> 
			</label>
			
			<div class="clearfix"></div>
			
			<label class="form-field pull-left">
				Data de nascimento:<br>
				<g:render template="/templatesCadastroUsuario/dataDeNascimento" model="['dataDeNascimento': profissional?.dataDeNascimento]"/> 
			</label>

			<label class="form-field pull-right">
				Profissão: <a class="help" href="" title="Profissão:" data-content="Não encontrou sua profissão? <strong>Clique e faça uma sugestão</strong>.">[?]</a><br>
				<g:render template="/templatesCadastroUsuario/profissoes" model="['profissoes': profissoes, 'profissaoSelecionada': profissional?.profissao]"/> 
			</label>

            <div class="clearfix"></div>

			<label class="form-field pull-left">
				Código do conselho regional:<br>
				<g:textField name="codigoConselhoRegional" id="codigoConselhoRegional" value="${profissional?.codigoConselhoRegional}"/>
			</label>
			
			<label class="form-field pull-right">
                Certificado do CRM:<br>

                <g:set var="usuarioComCertificadoCRM" value="${arquivos && arquivos.size() >= 1}" />
                <g:if test="${usuarioComCertificadoCRM}">
                    <div class="fileupload fileupload-exists" data-provides="fileupload">
                </g:if>
                <g:else>
                    <div class="fileupload fileupload-new" data-provides="fileupload">
                </g:else>
                    <div class="input-append">
                        <div class="uneditable-input span3"><i class="icon-file fileupload-exists"></i> 
                        	<span class="fileupload-preview">
                        	<g:if test="${usuarioComCertificadoCRM}">
                        		<a href="${g.resource( dir: grailsApplication.config.arquivo.diretorio.nome.certificadoCRM ?: 'certificadoCRM', file:"${arquivos[0].nome}") }">${arquivos[0].nomeOriginal}</a>
                        	</g:if>
                       		</span>
                        </div>
                        <span class="btn btn-file">
                        	<span class="fileupload-new">Alterar</span>
                        	<span class="fileupload-exists">Alterar</span>
                        	<input name="certificadoCRM" type="file" accept=".pdf,.doc,.docx" />
                        </span>
                    </div>
                </div>
			</label>
			
			<div class="clearfix"></div>
						
			<div id="username">
				<label class="form-field pull-left">
					Nome de usuário:<br>
					<g:textField name="urlProfile" id="urlProfile" value="${usuario?.urlProfile}"/>
				</label>

				<div class="form-field pull-right">
					Este campo 
				</div>
			</div>

			<div class="clearfix"></div>
			<br><br>

			<h1>Informações profissionais</h1>

			<h4>
				<i class="icon-check"></i> Especialidade(s):
			</h4>
			<g:textArea name="especialidade" id="especialidade" value="${profissional?.especialidade}"/>

			<h4>
				<i class="icon-certificate"></i> Patologia(s):
			</h4>
			<g:textArea name="patologia" id="patologia" value="${profissional?.patologia}"/>
			
			<h4>
				<i class="icon-list-alt"></i> Currículo:
			</h4>
			<g:textArea name="curriculo" id="curriculo" value="${profissional?.curriculo}"/>
		</div>

		<div class="clearfix"></div>

		<div class="form-actions" style="text-align:right">				
			<button type="submit" class="btn btn-success"> Salvar</button>
			<g:link controller='pesquisa' action="index" class="btn">Cancelar</g:link>
		</div>
	</g:form>
</body>

</html>