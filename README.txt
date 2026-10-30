CONTROLE DE FREELANCERS — INSTALAÇÃO

1. Crie um projeto em https://supabase.com/dashboard
2. No SQL Editor, execute todo o conteúdo de supabase.sql (uma única vez em projeto novo).
3. Em Authentication > Users, crie um usuário por e-mail com senha forte; marque confirmação de e-mail se a interface oferecer. Não habilite cadastro público de usuários.
4. Em Project Settings / Connect / API Keys, copie a Project URL e a chave publishable (ou anon). Nunca utilize service_role/secret no navegador.
5. Edite config.js e substitua os dois textos COLE_AQUI.
6. Teste localmente com um servidor HTTP, por exemplo: python3 -m http.server 8000 e abra http://localhost:8000.
7. Publique a pasta inteira na Vercel como projeto estático (sem build). O config.js deve acompanhar o index.html.
8. Entre com o e-mail e senha criados. Repita o acesso nos outros computadores/celulares.

IMPORTANTE: O login é único e compartilhado. A conta permite acesso completo aos registros. Proteja a senha, ative MFA se possível e não compartilhe o link com pessoas não autorizadas. A chave publishable não é secreta; a segurança depende das políticas RLS e do login. O sistema atualiza a cada 10 segundos e ao voltar à aba.

Os dados da versão antiga em localStorage NÃO são importados automaticamente. Esta versão não calcula pagamentos.
