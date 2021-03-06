﻿&НаКлиенте
Перем ТестКлиент, ГлавноеОкноТестКлиента, ФормаНовогоТовара, МассивОбъектов;

&НаКлиенте
Перем ВводимыйТекст, ТекстКомментария, ИмяВнешнейКомпоненты, КонтекстJavaScript;

&НаКлиенте
Перем ИдентификаторКомпоненты, ВнешняяКомпонента;

Процедура ПолучитьНовыйИдентификатор()
	
	ИдентификаторКлиента = "X" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	Элементы.ИдентификаторКлиента.СписокВыбора.Добавить(ИдентификаторКлиента);
	АдресURL = ПолучитьСтрокуЗапуска(АдресПубликации, ИдентификаторКлиента);
	
КонецПроцедуры

&НаСервере
Процедура СоздатьПользователей()
	
	Пользователи = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Если Пользователи.Количество() > 0 Тогда Возврат КонецЕсли;
	НовыйПользователь = ПользователиИнформационнойБазы.СоздатьПользователя();
	НовыйПользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях = Ложь;
	НовыйПользователь.Роли.Добавить(Метаданные.Роли.Администратор);
	НовыйПользователь.АутентификацияСтандартная = Истина;
	НовыйПользователь.ПолноеИмя = "Администратор";
	НовыйПользователь.Имя = "Администратор";
	НовыйПользователь.Записать();
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПортБраузера = 9222;
	АдресПубликации = "http://localhost/test/";
	ПолучитьНовыйИдентификатор();
	СоздатьПользователей();

	МакетКомпоненты = Обработки.VA_1ChromeDev.ПолучитьМакет("VA_1cWinCtrl");
	МестоположениеКомпоненты = ПоместитьВоВременноеХранилище(МакетКомпоненты, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСтрокуЗапуска(АдресПубликации, ИдентификаторКлиента)
	
	Возврат АдресПубликации + "?N=Администратор&P=&L=ru&VL=ru&DisableStartupMessages&DisplayAllFunctions&EnableCheckModal&O=Normal&TESTCLIENT&TESTCLIENTID=" + ИдентификаторКлиента;
	
КонецФункции	

&НаКлиенте
Процедура ВыполнитьПодключениеВнешнейКомпоненты(ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПодключениеВнешнейКомпонентыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	НачатьПодключениеВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты, ИдентификаторКомпоненты, ТипВнешнейКомпоненты.Native); 
	
КонецПроцедуры	

&НаКлиенте
Процедура ПодключениеВнешнейКомпонентыЗавершение(Подключение, ДополнительныеПараметры) Экспорт
	
	Если Подключение Тогда
		ВнешняяКомпонента = Новый("AddIn." + ИдентификаторКомпоненты + ".WindowsControl");
		ОписаниеОповещения = Новый ОписаниеОповещения("ПолученаВерсияКомпоненты", ЭтотОбъект);
		ВнешняяКомпонента.НачатьПолучениеВерсия(ОписаниеОповещения);
	ИначеЕсли ДополнительныеПараметры = Истина Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключениеВнешнейКомпоненты", ЭтотОбъект, Ложь);
		НачатьУстановкуВнешнейКомпоненты(ОписаниеОповещения, МестоположениеКомпоненты);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПолученаВерсияКомпоненты(Значение, ДополнительныеПараметры) Экспорт
	
	Заголовок = "Управление браузером, версия " + Значение;
	
КонецПроцедуры	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		Отказ = Истина;
		Возврат;
	#КонецЕсли
	
	ИдентификаторКомпоненты = "_" + СтрЗаменить(Новый УникальныйИдентификатор, "-", "");
	ВыполнитьПодключениеВнешнейКомпоненты(Истина);
	
	СисИнфо = Новый СистемнаяИнформация;
	
	Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 
		ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
	
		Shell = Новый COMОбъект("WScript.Shell");
	    ProgramFiles = Shell.ExpandEnvironmentStrings("%ProgramFiles%");   	
		
		ИмяФайла = "\Google\Chrome\Application\chrome.exe";
		Файл = Новый Файл(ProgramFiles + ИмяФайла);
		Если Файл.Существует() Тогда
			ФайлПриложения = Файл.ПолноеИмя;
		Иначе
		    ProgramFiles = Shell.ExpandEnvironmentStrings("%ProgramFiles(x86)%");   	
			Файл = Новый Файл(ProgramFiles + ИмяФайла);
			Если Файл.Существует() Тогда
				ФайлПриложения = Файл.ПолноеИмя;
			Иначе
				Сообщить("Не найден исполняемый файл Google Chrome");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйИдентификатор(Команда)

	ПолучитьНовыйИдентификатор();
	
КонецПроцедуры

&НаКлиенте
Процедура АдресПубликацииПриИзменении(Элемент)

	АдресURL = ПолучитьСтрокуЗапуска(АдресПубликации, ИдентификаторКлиента);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьБиблиотекуJavaScript(ИмяМакета)
	
	АдресХранилища = ПолучитьМакетНаСервере(ИмяМакета);
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресХранилища);
	УдалитьИзВременногоХранилища(АдресХранилища);
	
	СтрокаBase64 = Base64Строка(ДвоичныеДанные);
	СтрокаBase64 = СтрЗаменить(СтрокаBase64, Символы.ПС, "");
	СтрокаBase64 = СтрЗаменить(СтрокаBase64, Символы.ВК, "");
	ДлинаСтроки = СтрДлина(СтрокаBase64);
	РазмерБуфера = 3000;
	Позиция = 1; 
	Пока Позиция <= ДлинаСтроки Цикл
		Буфер = Сред(СтрокаBase64, Позиция, РазмерБуфера);
		Буфер = "window.base64vanessa" + ?(Позиция=1,"","+") + "='" + Буфер + "';";
		Позиция = Позиция + РазмерБуфера;
		ВыполнитьJavaScript(Буфер);
	КонецЦикла;
	
	ВыполнитьJavaScript(
	"eval.apply(null,[decodeURIComponent(atob(window.base64vanessa).split('').map(
	|c => '%'+('00'+c.charCodeAt(0).toString(16)).slice(-2)).join(''))]);");
	
КонецПроцедуры 	

&НаКлиенте
Процедура ВыполнитьТест(Команда)
	
	ТестКлиент = Неопределено;
	ГлавноеОкноТестКлиента = Неопределено;
	ФормаНовогоТовара = Неопределено;
	
	// Установить соединение с клиентом тестирования.
	ТестКлиент = Вычислить("Новый ТестируемоеПриложение(ИмяСервера, ПортСервера, ИдентификаторКлиента)");
	
	// 5 раз повторить попытку установить соединение, так как приложение может запускаться медленно.
	МаксИтераций = 5;
	Для Счетчик = 1 По МаксИтераций Цикл
	
		Попытка
			ТестКлиент.УстановитьСоединение();
			Прервать;
			
		Исключение
			
			// Вывести только последнее сообщение.                       
			Если Счетчик = МаксИтераций Тогда
				Сообщить(ОписаниеОшибки());
				Возврат;
				
			КонецЕсли;	
			
		КонецПопытки;
	
	КонецЦикла;   // установка соединения с клиентом тестирования
	
	Для каждого ТекущееОкно из ТестКлиент.ПолучитьПодчиненныеОбъекты() Цикл
		Если Не ТекущееОкно.Основное Тогда
			ТекущееОкно.Закрыть(); 
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ДочернееОкно из ТестКлиент.ПолучитьПодчиненныеОбъекты() Цикл
		Если Не ДочернееОкно.Основное Тогда 
			ДочернееОкно.Закрыть();
		КонецЕсли;
	КонецЦикла;
	
	ГлавноеОкноТестКлиента = ТестКлиент.ПолучитьАктивноеОкно();
	ГлавноеОкноТестКлиента.ВыполнитьКоманду("e1cib/navigationpoint/VA_Подсистема");
	ГлавноеОкноТестКлиента.ВыполнитьКоманду("e1cib/navigationpoint/VA_Подсистема/Справочник.VA_ПримерДанных.Команда.ОткрытьСписок");
	
	Скрипт = 
	"{
	|
	|let enjoyhint = new EnjoyHint();
	|let button = elem('ФормаСоздать');
	|let text = 'Нажмите кнопку «Создать» для ввода нового элемента!';
	|let array_enjoy = [{selector:button, description: text, showSkip:false, shape:'circle'}];
	|enjoyhint.set(array_enjoy); 
	|enjoyhint.run(); 
	|$('.enjoyhint_close_btn').hide();
	|setTimeout(() => (enjoyhint.stop()), 5000);
	|
	|}";
	ВыполнитьJavaScript(Скрипт);
	
	ПодключитьОбработчикОжидания("ВыполнитьТест_Шаг2", 5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьТест_Шаг2()
	
	ИмяТестируемойФормы = "Справочник.VA_ПримерДанных.Форма.ФормаСписка";
	Если НЕ ТестКлиент.ОжидатьОтображениеОбъекта(Тип("ТестируемаяФорма"), , ИмяТестируемойФормы, 10) Тогда
		Сообщить("Не удалось открыть форму списка справочника в течение 10 секунд.");
		Возврат;
	КонецЕсли;
	
    ГлавноеОкноТестКлиента.ВыполнитьКоманду("e1cib/command/Справочник.VA_ПримерДанных.Команда.Создать");
	
	ИмяТестируемойФормы = "Справочник.VA_ПримерДанных.Форма.ФормаЭлемента";
	Если НЕ ТестКлиент.ОжидатьОтображениеОбъекта(Тип("ТестируемаяФорма"), , "Справочник.VA_ПримерДанных.Форма.ФормаЭлемента", 10) Тогда
		Сообщить("Не удалось открыть форму нового элемента справочника в течение 10 секунд.");
		Возврат;
		
	КонецЕсли;
	
	Скрипт = "arrow(border('ФормаСоздать', 5000), 'Наименование', 5000, {color:'red', size: 5});";
	ВыполнитьJavaScript(Скрипт);
	
	ПодключитьОбработчикОжидания("ВыполнитьТест_Шаг3", 5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьТест_Шаг3()
	
	ДатаВремя = ТекущаяДата();
	ВводимыйТекст = Формат(ДатаВремя, "ДЛФ=DDT");
	ДатаВремя = Час(ДатаВремя) + Минута(ДатаВремя) / 100;
	ФормСтрока = "Л = ru_RU; ДП = Истина";
	ПарПредмета="час,часа,часов,м,минуте,минуты,минут,ж,2";
	ТекстКомментария = ЧислоПрописью(ДатаВремя, ФормСтрока, ПарПредмета);
	
	ИмяТестируемойФормы = "Справочник.VA_ПримерДанных.Форма.ФормаЭлемента";
	ФормаНовогоТовара = ТестКлиент.НайтиОбъект(Тип("ТестируемаяФорма"), , ИмяТестируемойФормы);
	ПолеНаименование = ФормаНовогоТовара.НайтиОбъект(Тип("ТестируемоеПолеФормы"), , "Наименование");
	ПолеНаименование.ВвестиТекст(ВводимыйТекст);
	
	Скрипт = "arrow(rect('Заполните поле «Комментарий»', 5000), border('Комментарий', 5000), 5000, {color:'red', size: 3});";
	ВыполнитьJavaScript(Скрипт);
	
	ПодключитьОбработчикОжидания("ВыполнитьТест_Шаг4", 5, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьТест_Шаг4()
	
	// Заполнить поле "Артикул". 
	// Оно неактивно, поэтому перед заполнением нужно его активизировать.
	ПолеАртикул = ФормаНовогоТовара.НайтиОбъект(Тип("ТестируемоеПолеФормы"), , "Комментарий");
	ПолеАртикул.Активизировать();
	
	
	ВнешняяКомпонента.ЭмуляцияВводаТекста(ТекстКомментария, 100);
	
	Скрипт = 
	"{
	|
	|let find_btn = elem('ФормаЗаписатьИЗакрыть');
	|let enjoyhint = new EnjoyHint();
	|let text = 'Для записи нового элмента нажмите кнопку «Записать и закрыть»!';
	|let array_enjoy = [{selector:find_btn,description: text, showSkip:false,}];
	|enjoyhint.set(array_enjoy); 
	|enjoyhint.run(); 
	|$('.enjoyhint_close_btn').hide();
	|setTimeout(() => (enjoyhint.stop()), 5000);
	|
	|}";
		
	ВыполнитьJavaScript(Скрипт);
	
	ПодключитьОбработчикОжидания("ВыполнитьТест_Шаг5", 5, Истина);
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьТест_Шаг5()
	
	// Записать и закрыть новый товар, нажав на кнопку "Записать и закрыть".
	КнопкаЗаписатьИЗакрыть = ФормаНовогоТовара.НайтиОбъект(Тип("ТестируемаяКнопкаФормы"), , "ФормаЗаписатьИЗакрыть");
	КнопкаЗаписатьИЗакрыть.Нажать();
	
	
	///////////////////////////////////////////////////////////////////////////////////////////////
	// *** Проверить выполнение теста - найти записанный новый товар в списке и прочитать его поля.

	// Получить таблицу товаров из формы списка товаров.
	ИмяТестируемойФормы = "Справочник.VA_ПримерДанных.Форма.ФормаСписка";
	ФормаТоваров = ТестКлиент.НайтиОбъект(Тип("ТестируемаяФорма"), , ИмяТестируемойФормы);
	СписокТоваров = ФормаТоваров.НайтиОбъект(Тип("ТестируемаяТаблицаФормы"), , "Список");
	
	// Встать в начало таблицы.
	СписокТоваров.ПерейтиКПервойСтроке();
	
	// Найти в таблице строку с тестируемым товаром по наименованию товара.
	ТестируемыйТоварНайден = Ложь;
	Пока Истина Цикл
   		НаименованиеТовара = СписокТоваров.ПолучитьТекстЯчейки("Наименование");

  		// Это искомый товар - выходим из цикла.
   		Если НаименованиеТовара = ВводимыйТекст Тогда
    		ТестируемыйТоварНайден = Истина;
    		Прервать;

   		КонецЕсли; 

   		// Это не тот товар - переходим к следующей строке, если она есть.
   		Попытка
      		// Если следующей строки нет, будет исключение и мы выйдем из цикла
      		СписокТоваров.ПерейтиКСледующейСтроке();
   		Исключение
      		Прервать;
   		КонецПопытки; 
	КонецЦикла;
	
	Скрипт = "arrow(selected(), 'ФормаКоманднаяПанельСписокСтрокаПоиска', 5000, {color:'red', size: 3});";
	ВыполнитьJavaScript(Скрипт);

	ТестКлиент = Неопределено;
	ГлавноеОкноТестКлиента = Неопределено;
	ФормаНовогоТовара = Неопределено;

КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьБраузер(Команда)
	
	СтрокаКоманды = """" + ФайлПриложения + """ about:blank --remote-debugging-port=" + Формат(ПортБраузера, "ЧГ=");
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗапущенБраузер", ЭтотОбъект);
	НачатьЗапускПриложения(ОписаниеОповещения, СтрокаКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапущенБраузер(КодВозврата, ДополнительныеПараметры) Экспорт
	
	// Ничего не делаем
	
КонецПроцедуры

&НаСервере
Функция ЗаголовокКоманды(ИмяКоманды)
	
	Возврат Команды.Найти(ИмяКоманды).Заголовок;
	
КонецФункции	

&НаКлиенте
Процедура ОшибкаБраузера(Команда)
	
	ИнформационныйТекст = 
	"Перед вызовом команды «" + ЗаголовокКоманды(Команда.Имя) + "»
	|закройте все открытые окна Google Chrome
	|и запустите снова кнопкой «Запустить браузер».";
	ПоказатьПредупреждение(, ИнформационныйТекст, 10);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьМакетНаСервере(ИмяМакета)
	
	Возврат ПоместитьВоВременноеХранилище(ПолучитьОбщийМакет(ИмяМакета), УникальныйИдентификатор);
	
КонецФункции	

&НаКлиенте
Процедура ЗапуститьКлиентТестирования(Команда)
	
	HTTPСоединение = Новый HTTPСоединение("localhost", 9222, , , , 10);
	АдресДляЗапуска = ПолучитьСтрокуЗапуска(АдресПубликации, ИдентификаторКлиента);
	
	HTTPЗапрос = Новый HTTPЗапрос("/json/new?" + АдресДляЗапуска);
	HTTPОтвет = HTTPСоединение.Получить(HTTPЗапрос);
	ТекстJSON = HTTPОтвет.ПолучитьТелоКакСтроку();
	ДанныеJSON = ПрочитатьСтрокуJSON(ТекстJSON);
	АдресВебСокет = ДанныеJSON.webSocketDebuggerUrl;
	ИдентификаторФрейма = ДанныеJSON.id;
	
	ОшибкаВебСокет = ВнешняяКомпонента.ОткрытьВебСокет(АдресВебСокет);
	Если НЕ ПустаяСтрока(ОшибкаВебСокет) Тогда
		Сообщить("Ошибка подключения WebSocket: " + ОшибкаВебСокет);
		Возврат;
	КонецЕсли;
	
	ПараметрыКоманды = Новый Структура("frameId", ИдентификаторФрейма);
	ДанныеJSON = ВыполнитьКомандуХрома("Page.createIsolatedWorld", ПараметрыКоманды);
	КонтекстJavaScript = ДанныеJSON.result.executionContextId;
	Постфикс = Формат(ТекущаяУниверсальнаяДатаВМиллисекундах(), "ЧГ=");
	
	ПодключитьБиблиотекуJavaScript("VA_jQuery");
	ПодключитьБиблиотекуJavaScript("VA_Library");
	
	//ВыполнитьJavaScript("	
	//|
	//|(function (base, files) {
	//|    files.forEach(file => fetch(base + file)
	//|        .then(response => response.text())
	//|        .then(text => eval.apply(null, [text]))
	//|    )
	//|    let node = document.createElement('link');
	//|    node.href = '/vanessa/enjoyhint.css';
	//|    node.rel = 'stylesheet';
	//|    window.top.document.body.appendChild(node);
	//|}('http://localhost/vanessa/', [
	//|    'jquery.min.js',
	//|    'enjoyhint.min.js',
	//|    'leader-line.min.js',
	//|    'library.js?" + Постфикс +"',
	//|]));
	//|
	//|");	
	//
	
КонецПроцедуры

&НаКлиенте
Функция ПрочитатьСтрокуJSON(ТекстJSON)
	
	Если ПустаяСтрока(ТекстJSON) Тогда
		Возврат Новый Структура;
	КонецЕсли;

	ЧтениеJSON = Новый ЧтениеJSON();
	ЧтениеJSON.УстановитьСтроку(ТекстJSON);
	Возврат ПрочитатьJSON(ЧтениеJSON);
	
КонецФункции

&НаКлиенте
Функция ЗаписатьОбъектJSON(ДанныеJSON)

	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	ЗаписатьJSON(ЗаписьJSON, ДанныеJSON);
	Возврат ЗаписьJSON.Закрыть();
	
КонецФункции

&НаКлиенте
Функция ВыполнитьКомандуХрома(ИмяКоманды, Параметры)
	
	ДанныеJSON = Новый Структура("id,method,params", 1, ИмяКоманды, Параметры);
	ТекстJSON = ВнешняяКомпонента.ПослатьВебСокет(ЗаписатьОбъектJSON(ДанныеJSON));
	Возврат ПрочитатьСтрокуJSON(ТекстJSON);
	
КонецФункции

&НаКлиенте
Функция ВыполнитьJavaScript(ТекстJavaScript)
	
	ПараметрыКоманды = Новый Структура("expression, contextId", ТекстJavaScript, КонтекстJavaScript);
	Возврат ВыполнитьКомандуХрома("Runtime.evaluate", ПараметрыКоманды);
	
КонецФункции

&НаКлиенте
Процедура ВыполненJavaScript(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
//	Сообщить(РезультатВызова);
	
КонецПроцедуры

&НаКлиенте
Процедура НачатьВызовВебСокет(ОписаниеОповещения, Команда, Параметры)
	
	ДанныеJSON = Новый Структура("id,method,params", 1, Команда, Параметры);
	КомандаJSON = ЗаписатьОбъектJSON(ДанныеJSON);
	ВнешняяКомпонента.НачатьВызовПослатьВебСокет(ОписаниеОповещения, КомандаJSON);
	
КонецПроцедуры	
	
&НаКлиенте
Процедура ПолучитьСнимокЭкрана(Команда)

	ПараметрыМетода = Новый Структура("format,quality,fromSurface", "png", 85, Ложь);
	ДанныеJSON = Новый Структура("id,method,params", 1, "Page.captureScreenshot", ПараметрыМетода);
	ОписаниеОповещения = Новый ОписаниеОповещения("ПолученСнимокЭкрана", ЭтотОбъект);
	НачатьВызовВебСокет(ОписаниеОповещения, "Page.captureScreenshot", ПараметрыМетода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолученСнимокЭкрана(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(РезультатВызова);
	ДанныеJSON = ПрочитатьJSON(ЧтениеJSON);
	Если ДанныеJSON.Свойство("result") Тогда
		ДвоичныеДанные = Base64Значение(ДанныеJSON.result.data);
		СнимокЭкрана = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура ФайлПриложенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбранФайлБраузера", ЭтотОбъект);
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла = Истина;
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ДиалогВыбораФайла.Показать(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбранФайлБраузера(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") Тогда
		Для каждого ЭлементМассива из ВыбранныеФайлы Цикл
			ФайлПриложения = ЭлементМассива;
			Прервать;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Отказ = НЕ ЗавершениеРаботы;
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьКартинку(Команда)
	
	Если НЕ ПустаяСтрока(СнимокЭкрана) Тогда
		УдалитьИзВременногоХранилища(СнимокЭкрана);
		СнимокЭкрана = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПолныйЭкран(Команда)
	
	ВнешняяКомпонента.НачатьВызовЭмуляцияНажатияКлавиши(Новый ОписаниеОповещения, 122, 0);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаJavaScript(Команда)
	
	ПараметрыКоманды = Новый Структура("expression, contextId", ТекстJavaScript, КонтекстJavaScript);
	ДанныеJSON = ВыполнитьКомандуХрома("Runtime.evaluate", ПараметрыКоманды);
	
	РезультатJavaScript.Очистить();
	
	Если ДанныеJSON.Свойство("result") Тогда
		Для каждого КлючЗначение из ДанныеJSON.result.result Цикл
			Стр = РезультатJavaScript.Добавить();
			ЗаполнитьЗначенияСвойств(Стр, КлючЗначение);
		КонецЦикла;
	КонецЕсли;
	
	НаборЗначений = Неопределено;
	Если ДанныеJSON.Свойство("error", НаборЗначений) Тогда
		Для каждого КлючЗначение из НаборЗначений Цикл
			Стр = РезультатJavaScript.Добавить();
			ЗаполнитьЗначенияСвойств(Стр, КлючЗначение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ДобавитьОбъект(ТекущийОбъект, РодительскийУзел)
	
	ТипОбъекта = ТипЗнч(ТекущийОбъект);
	НоваяСтр = РодительскийУзел.ПолучитьЭлементы().Добавить();
	НоваяСтр.Тип = ТипОбъекта;
	НоваяСтр.Объект = МассивОбъектов.Количество();
	МассивОбъектов.Добавить(ТекущийОбъект);
	ЗаполнитьЗначенияСвойств(НоваяСтр, ТекущийОбъект);
	Если ТипОбъекта = Тип("ТестируемоеОкноКлиентскогоПриложения") Тогда
		НоваяСтр.ТекстЗаголовка = ТекущийОбъект.Заголовок;
		Попытка
			КомандныйИнтерфейс = ТекущийОбъект.ПолучитьКомандныйИнтерфейс();
			СтрокаИнтерфейса = ДобавитьОбъект(КомандныйИнтерфейс, НоваяСтр);
		Исключение
		КонецПопытки;
	ИначеЕсли ТипОбъекта = Тип("ТестируемыйКомандныйИнтерфейсОкна") Тогда
		
	ИначеЕсли ТипОбъекта = Тип("ТестируемаяФорма") Тогда
		НоваяСтр.Имя = ТекущийОбъект.ИмяФормы;
	Иначе
		НоваяСтр.Имя = ТекущийОбъект.Имя;
	КонецЕсли;
	
	Для каждого ДочернийОбъект из ТекущийОбъект.ПолучитьПодчиненныеОбъекты() Цикл
		ДобавитьОбъект(ДочернийОбъект, НоваяСтр);
	КонецЦикла;
	
	Возврат НоваяСтр;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьЭлементыФормы(Команда)

	МассивОбъектов = Новый Массив;
	ИерархияЭлементов.ПолучитьЭлементы().Очистить();
	Для каждого ДочернийОбъект из ТестКлиент.ПолучитьПодчиненныеОбъекты() Цикл
		НоваяСтр = ДобавитьОбъект(ДочернийОбъект, ИерархияЭлементов);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияЭлементовПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ИерархияЭлементов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	ТекущийОбъект = МассивОбъектов[ТекущиеДанные.Объект];
	
	Текст = "
	|border('" + ТекущиеДанные.Имя + "', 3000);
	|border(label('" + ТекущиеДанные.Имя + "'), 3000, {color: 'green'});
	|";
 	
	ПараметрыКоманды = Новый Структура("expression, contextId", Текст, КонтекстJavaScript);
	ДанныеJSON = Новый Структура("id,method,params", 1, "Runtime.evaluate", ПараметрыКоманды);
	ТекстJSON = ЗаписатьОбъектJSON(ДанныеJSON);
	ВнешняяКомпонента.НачатьВызовПослатьВебСокет(Новый ОписаниеОповещения, ТекстJSON);
	
КонецПроцедуры

&НаКлиенте
Процедура ИерархияЭлементовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ИерархияЭлементов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда Возврат КонецЕсли;
	ТекущийОбъект = МассивОбъектов[ТекущиеДанные.Объект];
	
	Попытка	
		ТекущийОбъект.Активизировать(); 
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьОбъкты(Команда)
	
	Если ТестКлиент = Неопределено Тогда 
		ТестКлиент = Вычислить("Новый ТестируемоеПриложение(ИмяСервера, ПортСервера, ИдентификаторКлиента)");
	КонецЕсли;

	МассивОбъектов = Новый Массив;
	ИерархияЭлементов.ПолучитьЭлементы().Очистить();
	Для каждого ДочернийОбъект из ТестКлиент.ПолучитьПодчиненныеОбъекты() Цикл
		НоваяСтр = ДобавитьОбъект(ДочернийОбъект, ИерархияЭлементов);
	КонецЦикла;
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаИерархияЭлементов;
	
КонецПроцедуры

