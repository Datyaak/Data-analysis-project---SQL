# Závěrečný projekt SQL – Analýza životní úrovně občanů

## Cíl projektu

Cílem projektu bylo vytvořit datové podklady pro analýzu vývoje životní úrovně občanů v České republice. Na základě otevřených dat byla analyzována dostupnost základních potravin, vývoj mezd, cen a HDP.

----------------------------------------------------------------
## Zadání
Úkolem bylo vypracovat odpovědi na předem definované otázky týkající se životní úrovně občanů, konkrétně dostupnosti základních potravin pro širokou veřejnost. K tomu bylo nutné vytvořit datový podklad z dostupných veřejných dat. Výstupem měly být dvě tabulky.
1. **Primární tabulka**
Obsahuje potřebná data k porovnání mezd a cen potravin pro Českou republiku za porovnatelné období
2. **Sekundární tabulka** 
Obsahuje dodatečná data o dalších evropských zemích.

### Zdrojová data
Pro vytvoření datového podkladu bylo možno využít následující datové sady:

**Primární tabulky:**
1. `czechia_payroll` – Informace o mzdách v různých odvětvích za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
2. `czechia_payroll_calculation` – Číselník kalkulací v tabulce mezd.
3. `czechia_payroll_industry_branch` – Číselník odvětví v tabulce mezd.
4. `czechia_payroll_unit` – Číselník jednotek hodnot v tabulce mezd.
5. `czechia_payroll_value_type` – Číselník typů hodnot v tabulce mezd.
6. `czechia_price` – Informace o cenách vybraných potravin za několikaleté období. Datová sada pochází z Portálu otevřených dat ČR.
7. `czechia_price_category` – Číselník kategorií potravin, které se vyskytují v našem přehledu.

**Číselníky sdílených informací o ČR:**
1. `czechia_region` – Číselník krajů České republiky dle normy CZ-NUTS 2.
2. `czechia_district` – Číselník okresů České republiky dle normy LAU.

**Dodatečné tabulky:**
1. `countries` - Všemožné informace o zemích na světě, například hlavní město, měna, národní jídlo nebo průměrná výška populace.
2. `economies` - HDP, GINI, daňová zátěž, atd. pro daný stát a rok.
----------------------------------------------------------------

## Obsah repozitáře
### README file
`README.md` – tento dokument

### Skripty pro vytvoření tabulek:
`t_adam_poncik_project_SQL_primary_final.sql`
`t_adam_poncik_project_SQL_secondary_final.sql`

### Skripty pro vytvořené pohledy:
`v_adam_poncik_project_SQL_primary_final_1.sql`
`v_adam_poncik_project_SQL_primary_final_2.sql`
`v_adam_poncik_project_SQL_primary_final_3.sql`
`v_adam_poncik_project_SQL_primary_final_4.sql`
`v_adam_poncik_project_SQL_primary_final_5.sql`

----------------------------------------------------------------

## Výstupy z projektu

### Tabulky

`t_adam_poncik_project_sql_primary_final` | Agregovaná data o mzdách a cenách potravin za ČR v průběhu let
`t_adam_poncik_project_sql_secondary_final` | Data o HDP evropských států v průběhu let

### Pohledy (views)

`v_adam_poncik_project_sql_primary_final_1` | Otázka 1 | Vývoj mezd podle odvětví
`v_adam_poncik_project_sql_primary_final_2` | Otázka 2 | Kupní síla pro chléb a mléko (první vs. poslední období)
`v_adam_poncik_project_sql_primary_final_3` | Otázka 3 | Růst cen potravin (procentuálně)
`v_adam_poncik_project_sql_primary_final_4` | Otázka 4 | Porovnání růstu cen a mezd
`v_adam_poncik_project_sql_primary_final_5` | Otázka 5 | Vliv HDP na růst mezd a cen

----------------------------------------------------------------

## Výsledky výzkumných otázek

1. **Rostou mzdy ve všech odvětvích, nebo v některých klesají?**  
   
    V průběhu sledovaného období došlo ke zvýšení průměrných mezd ve všech odvětvích. Ne každé jednotlivé období však zaznamenalo růst. 15 z 19 odvětví vykázalo alespoň jeden meziroční pokles průměrné mzdy. Nejvýraznější pokles napříč odvětvími nastal v roce 2013, kdy zaznamenalo pokles celkem 11 odvětví, přičemž právě tento rok zahrnuje 4 z 5 největších poklesů v celém sledovaném období.

2. **Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období?**  
    V obou případech byla data uvedena v požadovaných jednotkách (kg a litry), takže nebylo nutné provádět žádný přepočet.
    Na začátku sledovaného období bylo možné za průměrnou mzdu pořídit přibližně 1 287,5 kg chleba a 1 437 litrů mléka.
    Na konci sledovaného období to bylo již 1 342 kg chleba a 1 641,6 litrů mléka.
    Jedná se tedy o zvýšení kupní síly o přibližně 4 % u chleba a o 14 % u mléka.


3. **Která kategorie potravin zdražuje nejpomaleji?**  
   
    V průběhu měření zaznamenaly 2 kategorie potravin celkový pokles a to Cukr krystalový (kód: 118101) a Rajská jablka červená kulatá (kód: 117101). Všechny ostatní sledované kategorie potravin zaznamenaly celkový nárůst cen.

4. **Existuje rok, kdy ceny potravin rostly výrazně rychleji než mzdy (více než o 10 %)?**  
   
    V žádném roce sledovaného období nebyl zaznamenán rozdíl mezi růstem cen potravin a růstem mezd vyšší než 10 procentních bodů.
    Nejvýraznější odchylka nastala v roce 2013, kdy ceny potravin vzrostly, zatímco průměrné mzdy klesly.
    V důsledku toho se kupní síla obyvatel snížila o 6,66 p.b.

5. **Má růst HDP vliv na růst mezd a cen potravin?**  
   
    Na základě dostupných dat nebyla vysledována žádná závislost mezi změnami HDP a změnami cen potravin či mezd.
    Nebyla provedena korelační analýza ani regresní model, ale již z přehledu hodnot je patrná značná nesourodost.

    Například:
    -   V roce 2009 došlo k výraznému poklesu HDP o 4,66 %, cenová hladina klesla o 6,41 %, ale mzdy vzrostly o 3,16 %.

    -   V roce 2012 pokleslo HDP o 0,79 %, ale ceny vzrostly o 6,73 % a mzdy o 3 %.
    
    -   Následující rok, 2013, HDP pokleslo mírně o 0,05 %, přesto ceny vzrostly o 5,1 % a mzdy naopak poklesly o 1,56 %.

    Tyto rozdílné vývoje naznačují, že neexistuje žádný zřetelný pozitivní ani negativní korelační vztah mezi změnou HDP a změnami mezd či cen potravin v daném nebo následujícím roce.


----------------------------------------------------------------

##  Poznámky k datům

- Mzdy byly agregovány z kvartálních údajů (czechia_payroll), ceny z týdenních dat (czechia_price).
- Výsledky jsou založeny na ročních průměrech.
- Některé kategorie mohou mít neúplná data (chybějící roky u některých potravin apod.).

----------------------------------------------------------------

## Autor

Jméno a příjmení: Adam Pončík
Datum odevzdání: 29.7. 2025
