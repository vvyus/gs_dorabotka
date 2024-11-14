﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ГСД_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	//реквизит для показа выделенных сумм
	ДоработкаФормыСервер.ДобавитьСохраняемыйРеквизитИЭлементФормы(ЭтотОбъект, Элементы.ГруппаЗапускИЗавершениеРаботы, "ГСД_ВключитьПоказСуммыВыделенныхСтрок","Включить показ суммы выделенных строк");
	// реквизит для разрешения показа дней рождений
	ДоработкаФормыСервер.ДобавитьСохраняемыйРеквизитИЭлементФормы(ЭтотОбъект, Элементы.ГруппаЗапускИЗавершениеРаботы, "ГСД_ДниРожденияВТекущихДелах","Показ дней рождения в текущих делах");
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
&После("ЗаписатьНастройкиНаСервере")
Процедура ГСД_ЗаписатьНастройкиНаСервере(ПараметрыКлиента)
		СохранитьСвойстваКоллекции("ОбщиеНастройкиПользователя", ЭтотОбъект,
		"ГСД_ВключитьПоказСуммыВыделенныхСтрок");
        // дни рождения
		СохранитьСвойстваКоллекции("ОбщиеНастройкиПользователя", ЭтотОбъект,
		"ГСД_ДниРожденияВТекущихДелах");

КонецПроцедуры

#КонецОбласти

