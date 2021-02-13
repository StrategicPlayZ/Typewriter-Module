# Typewriter Module \[Supports RichText\]
https://devforum.roblox.com/t/supports-richtext-typewriter-module/946868

## Contents
  * [a](#first)

## Documentation
<!-- ==================DOCUMENTATION-BEGIN================== -->
<!--=====-->
<cc id="first"></cc>
* ### `Typewriter.new` *(function):*

  Creates a new **Typer** object. Each **TextLabel** should have a separate **Typer** object for it.
  
  **Arguments:**
    * no arguments
    
  **Returns:**
    * **Typer** object
<!--=====-->

<!--=====-->
* ### `Typer.OnTextUpdated` *(RBXScriptSignal):*
  
  A **Connection** to the **Typer** object that fires every time the text changes.
  
  **Arguments:**
    * **current_text** *(string):* The current text of the typewriter effect.
    * **final_text** *(string):* The final text of the typewriter effect.
  
  **Returns:**
    * no returns
<!--=====-->

<!--=====-->
* ### `Typer.OnTyperFinished` *(RBXScriptSignal):*

  A **Connection** to the **Typer** object that fires every time the **Typer** object finishes typing the text.
  
  **Arguments:**
    * **final_text** *(string):* The final text of the typewriter effect.
    
  **Returns:**
    * no returns
<!--=====-->

<!--=====-->
* ### `Typer:TypeText` *(function):*

  Starts typing the text and fires the callbacks connected to it every text update.
  
  **Arguments:**
    * **text** *(string):* The text it will type.
    * **interval** *(double):* How quickly it will type (seconds per character). Example: **0.016666 (60 characters per second)**.
    * **rich_text_enabled** *(bool):* Whether or not the text is rich or plain.
    * **yield** *(bool):* Whether or not the script should wait until the text has been typed.
    
  **Returns:**
    * **yield** *(bool):* Whether the script yielded or not.
<!--=====-->

<!--=====-->
* ### `Typer:AdjustSpeed` *(function):*

  Changes the speed of the typer in real-time.
  
  **Arguments:**
    * **interval** *(double):* The new speed (in seconds per character).
    
  **Returns:**
    * no returns
<!--=====-->

<!--=====-->
* ### `Typer:Stop` *(function):*

  Stops typing the text.
  
  **Arguments:**
    * no arguments
    
  **Returns:**
    * no returns
<!--=====-->

<!--=====-->
* ### `Typer:Pause` *(function):*

  Pauses typing the text.
  
  **Arguments:**
    * no arguments
    
  **Returns:**
    * no returns
<!--=====-->

<!--=====-->
* ### `Typer:Unpause` *(function):*

  Unpauses typing the text.
  
  **Arguments:**
    * no arguments
    
  **Returns:**
    * no returns
<!--=====-->

<!--=====-->
* ### `Typer:IsTyping` *(function):*

  Returns a boolean indicating whether the typer is currently typing or not.
  
  **Arguments:**
    * no arguments
    
  **Returns:**
    * **is_typing** *(bool):* Whether the **Typer** object is currently typing or not.
<!--=====-->

<!--=====-->
* ### `Typer:Destroy` *(function):*

  Destroys the **Typer** object.
  
  **Arguments:**
    * no arguments
    
  **Returns:**
    * no returns
<!--=====-->

<!-- ==================DOCUMENTATION-END================== -->
