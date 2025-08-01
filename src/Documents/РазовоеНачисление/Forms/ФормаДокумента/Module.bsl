#Область ОбработчикиСобытийФормы
&НаСервере
Процедура ГСД_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	ВключитьПоказСуммВыделенныхСтрок = ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекЗагрузить(
	"ОбщиеНастройкиПользователя", 
	"ГСД_ВключитьПоказСуммыВыделенныхСтрок",
	Ложь);                                		
	
	Если ВключитьПоказСуммВыделенныхСтрок Тогда //И (Объект.Начисление.Код="ПР009" ИЛИ Объект.Начисление.Код="ДН039") Тогда     //если единовременная премия, участие в собраниях
		//определяем имя реквизита с результатом суммирования
		// добавляем группу для реквизитов
		ГруппаДобавленныхРеквизитов=ДоработкаФормыСервер.ДобавитьГруппуДляРеквизитов(ЭтотОбъект,Элементы.ДатыНачалаОкончанияГруппа);
		//добавляем доп кнопку для показа расх по ндфл
		ДоработкаФормыСервер.ДобавитьКнопку(ЭтотОбъект,ГруппаДобавленныхРеквизитов,"ГСД_ПоказатьРасхождениеВНдфлПоДокументу");


	КонецЕсли;	

КонецПроцедуры

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ГСД_ПоказатьРасхождениеВНдфлПоДокументу()
	ТабДок=Новый ТабличныйДокумент;
	ТабДок.ФиксацияСверху=4;
	ТабДок.ФиксацияСлева=1;
	ТабДок.ТолькоПросмотр=Истина;
	ТабДок.АвтоМасштаб = Истина;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

	КоличествоРасхождений=ГСД_РассчитатьРасхождениеНдфлПоДокументу(ТабДок);                    
	
	Если КоличествоРасхождений>0 Тогда               
	    ТабДок.Показать(СтрШаблон("Расхождение в документе %1 по ндфл.",Объект.Ссылка));
	Иначе	
		ОбщегоНазначенияКЛиент.СообщитьПользователю("Расхождения не обнаружены!");
	КонецЕсли;	
	
КонецПроцедуры
#КонецОбласти

&НаСервере
Функция ГСД_РассчитатьРасхождениеНдфлПоДокументу(ТабДок)
	Данные    = Новый ТаблицаЗначений;
	Колонки   = Данные.Колонки;
   	Колонки.Добавить("ФизическоеЛицо", Новый ОписаниеТипов("Строка"));                             
	Колонки.Добавить("ПланНдфл", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(12, 2)));
	Колонки.Добавить("ФактНдфл", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(12, 2)));
    Колонки.Добавить("Расхождение", Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(12, 2)));
	
	Ндфл=Объект.НДФЛ.Выгрузить();
	Ндфл.Свернуть("ФизическоеЛицо","Налог");
	Ндфл.Индексы.Добавить("ФизическоеЛицо");
	Начисления=Объект.Начисления.Выгрузить();
	Начисления.Свернуть("Сотрудник","Результат");  
	
	Для Каждого Начисление Из Начисления Цикл
		Отбор=Новый Структура("ФизическоеЛицо",Начисление.Сотрудник.ФизическоеЛицо);
		СтрокиНдфл=Ндфл.НайтиСтроки(Отбор);
		Если СтрокиНдфл.Количество()>0 Тогда                                      
			ПланНдфл=1.3*Начисление.Результат*13/100;
			ФактНдфл=СтрокиНдфл[0].Налог;                     
			Налог=ФактНдфл-ПланНдфл;
			МодульНалога = ?(Налог > 0, Налог, -Налог);
			Если МодульНалога>2 Тогда   
				СтрТз=Данные.Добавить();
				СтрТз.ФизическоеЛицо=Начисление.Сотрудник.Наименование;
				СтрТз.Расхождение=МодульНалога;
				СтрТз.ПланНдфл=ПланНдфл;
				СтрТз.ФактНдфл=ФактНдфл;
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла;	
	
	Если Данные.Количество()>0 Тогда
		ДоработкаФормыСервер.ВывестиТаблицуЗначенийВТабличныйДокумент(ТабДок,Данные);
	КонецЕсли;
	
	Возврат Данные.Количество();
		
КонецФункции

#КонецОбласти