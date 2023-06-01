-- #1. How many campaigns and sources does CoolTShirts use? Which source is used for each campaign?
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;
-- There are 8 unique campaigns.

SELECT COUNT(DISTINCT utm_source)
FROM page_visits;
-- There are 6 unique sources.

SELECT DISTINCT utm_campaign, utm_source
FROM page_visits
GROUP BY 1;
-- Google and Email used twice as a UTM source. NYTimes, Medium, Facebook, and Buzzfeed used once as a UTM source.

-- #2. What pages are on the CoolTShirts website?
SELECT DISTINCT page_name
FROM page_visits;
-- 1 - landing_page, 2 - shopping_cart, 3 - checkout, 4 - purchase.

-- #3. How many first touches is each campaign responsible for?
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as 'first_touch_at'
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign, pv.utm_source,
  COUNT(ft.first_touch_at) AS 'first_touch_count'
FROM first_touch AS 'ft'
JOIN page_visits AS 'pv'
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 3;
-- cool-tshirts-search: 169, ten-crazy-cool-tshirts-facts: 576, getting-to-know-cool-tshirts: 612, interview_with_cool-tshirts-founder: 622.

-- #4. How many last touches is each campaign responsible for?
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as 'last_touch_at'
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign, pv.utm_source,
  COUNT(lt.last_touch_at) AS 'last_touch_count'
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY 1
ORDER BY 3;
-- cool-tshirts-search: 60, paid-search: 178, interview_with_cool-tshirts-founder: 184, ten-crazy-cool-tshirts-facts: 190, getting-to-know-cool-tshirts: 232, retargetting-campaign: 245, retargetting-ad: 443, weekly-newsletter: 447.

-- #5. How many visitors make a purchase? 
SELECT COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase';
-- 361 visitors made a purchase.

-- #6. How many last touches on the purchase page is each campaign responsible for?
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as 'last_touch_at'
    FROM page_visits
    GROUP BY user_id)
SELECT pv.utm_campaign, pv.utm_source,
  COUNT(lt.last_touch_at) AS 'last_touch_count'
FROM last_touch AS 'lt'
JOIN page_visits AS 'pv'
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
WHERE pv.page_name = '4 - purchase'
GROUP BY 1
ORDER BY 3;
-- cool-tshirts-search: 2, interview_with_cool-tshirts-founder: 7, getting-to-know-cool-tshirts: 9,ten-crazy-cool-tshirts-facts: 9, paid-search: 52, retargetting-campaign: 53, retargetting-ad: 112, weekly-newsletter: 114.

-- #7. CoolTShirts can re-invest in 5 campaigns. Given your findings in the project, which should they pick and why?
-- Weekly-newsletter and retargetting-ad are most important to reinvest in as they have the most last touches and the most last touches on the purchase page specifically so reinvesting in this campaign can ideally lead to more purchases. The interview-with-cool-tshirts-founder, getting-to-know-cool-tshirts, and ten-crazy-cool-tshirts-facts are also good campaigns to reinvest in as they contributed to the most first touch counts, which initially drew users in to browse the website.
