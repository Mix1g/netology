# netology
Test2
001
все файлы в поддиректории /.terraform/ файлы с расширением *.tfstate и с любым расширением файлы с именем crash.log, override.tf, override.tf.json файлы, имеющие в своём имени "_override.tf", "_override.tf.json" а также файлы с именами .terraformrc и terraform.rc
01010101


1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
Полный хеш: aefead2207ef7e2aa5dc81a34aedf0cad4c32545

$ git show aefea | head -n 1
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
2. Какому тегу соответствует коммит 85024d3?
Тегу v0.12.23

$ git tag -l --points-at 85024d3
v0.12.23
3. Сколько родителей у коммита b8d720? Напишите их хеши.
Два: 56cd7859e05c36c06b56d013b55a252d0bb7e158 и 9ea88f22fc6269854151c571162c5bcf958bee2b

$ git show --pretty=%P b8d720
56cd7859e05c36c06b56d013b55a252d0bb7e158 9ea88f22fc6269854151c571162c5bcf958bee2b
4. Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.
Между тегами 10 коммитов. Хеши и комментарии:

$ git log v0.12.23..v0.12.24 --oneline
33ff1c03b (tag: v0.12.24) v0.12.24
b14b74c49 [Website] vmc provider links
3f235065b Update CHANGELOG.md
6ae64e247 registry: Fix panic when server is unreachable
5c619ca1b website: Remove links to the getting started guide's old location
06275647e Update CHANGELOG.md
d5f9411f5 command: Fix bug when using terraform login on Windows
4b6d06cc5 Update CHANGELOG.md
dd01a3507 Update CHANGELOG.md
225466bc3 Cleanup after v0.12.23 release
5. Найдите коммит в котором была создана функция func providerSource ...
Функция func providerSource была создана в коммите 8c928e8358 от 02.04.2020

$ git grep -n 'func providerSource(.*)'
provider_source.go:23:func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
$ git log --oneline -S'func providerSource' provider_source.go
5af1e6234 main: Honor explicit provider_installation CLI config when present
8c928e835 main: Consult local directories as potential mirrors of providers
$ git checkout 8c928e835

git grep -n 'func providerSource(.*)'
provider_source.go:19:func providerSource(services *disco.Disco) getproviders.Source {
$ git blame -L 19,19 provider_source.go
8c928e8358 (Martin Atkins 2020-04-02 18:04:39 -0700 19) func providerSource(services *disco.Disco) getproviders.Source {
6. Найдите все коммиты в которых была изменена функция globalPluginDirs.
Функцию globalPluginDirs исправляли в пяти коммитах.

$ git grep 'func globalPluginDirs(.*)'
plugins.go:func globalPluginDirs() []string {
$ git log -L :globalPluginDirs:plugins.go  -s --oneline
78b122055 Remove config.go and update things using its aliases
52dbf9483 keep .terraform.d/plugins for discovery
41ab0aef7 Add missing OS_ARCH dir to global plugin paths
66ebff90c move some more plugin search path logic to command
8364383c3 Push plugin discovery down into command package
7. Кто автор функции synchronizedWriters?
Автор функции synchronizedWriters Martin Atkins. Он добавил её 2017-05-03 коммитом 5ac311e2a

Примерно в то же время, когда Андрей записывал курс, James Bardin удалил эту функцию коммитом bdfea50cc от Mon Nov 30 18:02:04 2020 с комментарием remove unused.

$ git log -S'func synchronizedWriters' --oneline
bdfea50cc remove unused
5ac311e2a main: synchronize writes to VT100-faker on Windows
git checkout 5ac311e2a

$ git grep -n 'func synchronizedWriters(.*)'
synchronized_writers.go:15:func synchronizedWriters(targets ...io.Writer) []io.Writer {
$ git blame -L 15,15 synchronized_writers.go
5ac311e2a9 (Martin Atkins 2017-05-03 16:25:41 -0700 15) func synchronizedWriters(targets ...io.Writer) []io.Writer {
